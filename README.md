---
title: "Readme"
author: "qnv"
date: "December 8, 2016"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```
s
## This contains a short explanation to run_analysis

This exercise is based on study data (cf. http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).  

Codebook.md contains a description of the variables given in the final tidy data set ProgrammingAssignment_TidyDataSet.txt.  

run_analsis.R contains the actual data processing consisting of the following steps 

1. input of the necessary train and test data from the raw data files
2. merging the data (column wise for features, subject, activity and row wise for train and test records)
3. selecting only variables that are means or standard deviations / renaming the activities with descriptive labels
4. Creating a tidy version of data (observations: Subject+Activity, Variables: Feature Measures) by
    + bringing the table into a long format
    + calculating the averages group wise per subject, activity and variable name 
    + spreading the resulting table so that opservations are in rows and variables in columns
