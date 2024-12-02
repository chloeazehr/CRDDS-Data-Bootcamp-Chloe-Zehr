# CRDDS-Data-Bootcamp-Chloe-Zehr
This repository contains R script and analyses of text data from South Carolina interviews with formerly enslaved men and women from the early twentieth century. 

## Disclaimer
The data used in this project contains racist profanity due to its historical context. I have taken care to avoid reinforcing or using such language in my analyses, while maintaining the integrity of the original text for research purposes.

---

## Research Questions
This project explores the following questions:

- **What does part-of-speech (POS) tagging reveal about noun co-occurrence patterns in interviews with formerly enslaved people?**  
- **How might these patterns reflect historical consensus or biases?**  
- **What perspectives can we glean from the interviewees, and what are the limitations of the data?**

---

## Dataset and Methodology

### Dataset
The text corpus for this project was derived from the first four volumes of *South Carolina’s Slave Narratives: A Folk History of Slavery in the United States from Interviews*, accessible through the [Project Gutenberg](https://www.gutenberg.org) online repository. Using the `gutenbergr` package in RStudio, I downloaded all four volumes along with basic metadata (Gutenberg IDs). The combined text is stored in a dataframe/variable called `scnarratives_works`. A cleaned version of the dataset is included as a CSV file in this repository. As many historians and humanists alike have pointed out, these WPA narratives are quite problematic sources due to how they were collected and their trasncriptions of African American vernacular English. It may be useful to recall James Balwin's words: “Language, incontestably, reveals the speaker. Language, also, far more dubiously, is meant to define the other—and, in this case, the other is refusing to be defined by a language that has never been able to recognize him. People evolve a language in order to describe and thus control their circumstances, or in order not to be submerged by a reality that they cannot articulate. (And, if they cannot articulate it, they are submerged.)” - James Baldwin, “If Black English Isn’t a Language, Then Tell Me, What Is?” (1979). 

### Preprocessing and Annotation
- **Part-of-Speech Tagging**: I used the `udpipe` package to annotate the corpus, creating the variable `scnarratives_annotated`, which includes POS tags for the text.  
- **Noun Co-occurrence Analysis**: A skipgram model with a 30-term window was employed to compute noun co-occurrences, a standard approach for textual analysis. This data was used to generate a network graph visualizing relationships between frequently co-occurring terms.

---

## Key Findings

1. **Semantic Connections**: The network graph reveals strong connections between terms like "master" and "slave," reflecting the perspectives of formerly enslaved interviewees.  
   - Unlike colonial archives, where "slave" is often linked to commodities and labor, the interview data connects the term to familial and community roles, such as "mother."
   
2. **Alternate Perspectives**: The data offers insights into how interviewees maintained their identities despite the systemic oppression of slavery, highlighting subaltern perspectives often absent from traditional archives.  

3. **Archival Context**: These narratives emphasize the importance of using digital methods to question dominant historical narratives and recover marginalized voices.

---

## Tools and Accessibility

### Tools Used
- **R Packages**: `gutenbergr`, `tidyverse`, `udpipe`  
- **Data Format**: Text data was processed into structured formats, stored in a dataframe, and annotated with POS tags.

### Data Accessibility
- The dataset originates from Project Gutenberg, a free and open-source resource, and adheres to FAIR principles:  
  - **Findable**, **Accessible**, **Interoperable**, and **Reusable**.  
- Project Gutenberg supports multiple formats (HTML, text files, eBooks) and is compatible with tools like dyslexic font browser extensions, enhancing accessibility for researchers.

### Limitations
- **Dialect and Language Variations**: The interviews preserve local dialects and early 20th-century English characteristics, leading to potential errors in computational analyses.  
- **Inconsistent Vocabulary**: Irregular spellings and terms require careful manual validation to ensure accuracy.  

---

## Acknowledgments
A special thanks to the team at CU Boulder’s CRDDS for their excellent guidance and support throughout this project.

## Licenses
CC0 1.0 Universal
