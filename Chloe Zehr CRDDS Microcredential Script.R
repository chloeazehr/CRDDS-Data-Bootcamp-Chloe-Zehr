#Packages loaded

library(gutenbergr)
library(tidytext)
library(tidyverse)
library(lexicon)
library(word2vec)
library(textdata)
library(udpipe)
library(igraph)
library(ggraph)
library(ggplot2)
library(vroom)
library(labeling)

#downloading South Carolina Folk tales and Interviews w/ formerly enslaved individuals from Project Gutenberg
#South Carolina 

scnarratives_vol1 <- gutenberg_download(18912) #downloading the text from the ebook ID found on Gutenberg's website
scnarratives_vol2 <- gutenberg_download(21508)
scnarratives_vol3 <- gutenberg_download(36022)
scnarratives_vol4 <- gutenberg_download(28170)

#cleaning: 
scnarratives_vol1_clean <- scnarratives_vol1[198:10110,] #removing publication information and tables of contents
scnarratives_vol2_clean <- scnarratives_vol2[126:9913,]
scnarratives_vol3_clean <- scnarratives_vol3[265:7998,]
scnarratives_vol4_clean <- scnarratives_vol4[124:8182,]

#binding my cleaned data together into one dataframe
scnarratives_works <- rbind(scnarratives_vol1_clean, scnarratives_vol2_clean, scnarratives_vol3_clean, scnarratives_vol4_clean)

#reading to CSV
write.csv(scnarratives_works, "C:\\Users\\chloe\\OneDrive\\Desktop\\CRDDS Data Bootcamp\\SouthCarolina_SlaveNarratives.csv", row.names=FALSE)


#Basic EDA: 
scnarratives_txt <- scnarratives_works$text #creating new variable that only contains text data
scnarratives_txt <- as.data.frame(scnarratives_txt)

scnarrtives_tokenized <- scnarratives_txt %>%
  unnest_tokens(word, scnarratives_txt)

#loading "stop words" premade lexicons
data("stop_words")

custom_sw <- custom_stop_words <- stop_words %>% #creating custom stop words list
  filter(lexicon != "SMART") # filtering for "snowball" lexicon, for my purposes it is a little too aggressive

scnarratives_tokenized_clean <- scnarrtives_tokenized %>%
  anti_join(custom_sw) %>% #remove stop words
  count(word, sort = TRUE) #generate overall word counts

scnarratives_txt_counts <- scnarratives_tokenized_clean %>%
  mutate(perc = n/sum(n)* 100)

wordfreq_graph <- scnarratives_txt_counts[1:25,]

#visualize top 25 most frequent words (includes dialect)
ggplot(wordfreq_graph) +
  aes(x = reorder(word, -perc), y = perc) + 
  geom_col() + 
  coord_flip() +
  xlab("Word") + 
  ylab("% Freqeuncy")




#POS Tagging for Exploratory Text Analysis 
ud_model <- udpipe_download_model(language = "english")  #importing the udpipe model for English
ud_model <- udpipe_load_model(ud_model$file_model)       

scnarratives_annotated <- udpipe_annotate(ud_model, x = scnarratives_works$text, doc_id = scnarratives_works$gutenberg_id) #here the udpipe annotate function automatically sorts through and tags the text data --- this step can take a significant amount of depending on the size of your corpus. 

scnarratives_annotated <- as.data.frame(scnarratives_annotated) #this turns the output of the annotate function into a more accessible and maleable dataframe


scnarratives_annotated_sel <- scnarratives_annotated %>% #selecting the metadata I want to use/see in a new dataframe: doc_id, token, lemma, and upos (the category that highlights the kind of part of speech)
  select(doc_id, token, lemma, upos)

scnarratives_nouns <- scnarratives_annotated_sel %>%
  filter(upos == "NOUN")



#generating noun co-occurence data: 
scnarratives_cooc_NOUN <- cooccurrence(x = scnarratives_annotated$lemma, #coocurrence is a function included in the udpipe package
                                    relevant = scnarratives_annotated$upos %in% c("NOUN"), skipgram = 30) 
scnarratives_cooc_NOUN <- as.data.frame(scnarratives_cooc_NOUN) 

sc_noun_top200 <- scnarratives_cooc_NOUN[20:220,] #removing some filler words from the results, this is subject to the data you are using/are interested in visualizing. Here I am choosing to look at the top 200 most co-occuring nouns.


#Visualize
sc_noun_top200 <- as.tibble(sc_noun_top200) #for the ggraph, we need our data in a tibble

scnarratives_NOUN_graph <- sc_noun_top200 %>%
  filter(cooc > 20) %>%     #looking at terms that co-occur more than 20 times                  
  graph_from_data_frame() 



set.seed(123) #setting the seed generates the same graph each time

ggraph(scnarratives_NOUN_graph, layout = "fr") +   
  geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "#ed9de9") + #customizing edges 
  geom_node_point(aes(size = igraph::degree(scnarratives_NOUN_graph)), shape = 1, color = "black") + #customizing nodes
  geom_node_text(aes(label = name), col = "darkblue", size = 5) #customizing text




