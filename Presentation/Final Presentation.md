Distracted Driving: Detecting Texting with Neural Networks
========================================================
author: Joseph Blubaugh
date: 29 March 2017
autosize: true
font-family: "DejaVu Sans Mono"
width: 2100
height: 1400
css: custom.css



Contents
========================================================

<br>

## 1) Data Extraction, Preparation, and Project Management

## 2) Exploratory Analysis and Model Proposal

## 3) Understanding Basic Neural Nets

## 4) Model Training and Selection

## 5) Exploring Model Effects

Data Introduction, Preparation, and Project Management
========================================================
class: section

Data Introduction
========================================================

  * The data in this project are of 8 driving simulations for 66 individuals ranging from 3,000 to 30,000 observations per simulation. 
  * Every simulation observation contains likelihood scores for 8 facial expressions recorded at a fixed interval of .03 seconds. 
  * Stimuli data which records targetted events introduced into each simulation and basic demographic data on each subject are also available.
  * There are over 6.7 million observations in the entire dataset spread accross 777 files. 

The data set used in this project was originally collected and analyzed in [Dissecting Driver Behaviors Under Cognitive, Emotional, Sensorimotor, and Mixed Stressors](http://www.nature.com/articles/srep25651), Scientific Reports 6, Article number: 25651 (2016).


**Simulation Data T001-001.xlsx**


| Frame.|   Time|  Anger| Contempt| Disgust|   Fear|    Joy|    Sad| Surprise| Neutral|ID       |
|------:|------:|------:|--------:|-------:|------:|------:|------:|--------:|-------:|:--------|
|      0| 0.0000| 0.0101|   0.0218|  0.0043| 0.0541| 0.5260| 0.0959|   0.0010|  0.2868|T001-001 |
|      1| 0.0333| 0.0101|   0.0218|  0.0043| 0.0541| 0.5260| 0.0959|   0.0010|  0.2868|T001-001 |
|      2| 0.0667| 0.0101|   0.0218|  0.0043| 0.0541| 0.5260| 0.0959|   0.0010|  0.2868|T001-001 |
|      3| 0.1000| 0.0080|   0.0187|  0.0032| 0.0375| 0.5353| 0.1050|   0.0011|  0.2911|T001-001 |
|      4| 0.1333| 0.0091|   0.0380|  0.0158| 0.0036| 0.6902| 0.0177|   0.0004|  0.2252|T001-001 |
|      5| 0.1667| 0.0104|   0.0450|  0.0139| 0.0030| 0.7157| 0.0162|   0.0003|  0.1955|T001-001 |

**Sample of Stimuli File**


| StartTime| EndTime| Event.Switch| Action.Type|Question.Number        |ID       |
|---------:|-------:|------------:|-----------:|:----------------------|:--------|
|      86.5|  246.50|            1|           1|Analytical Questions   |T001-005 |
|     508.5|  657.50|            1|           2|Mathematical Questions |T001-005 |
|     107.5|  269.25|            1|           3|Emotional Questions    |T001-006 |
|     521.0|  674.75|            1|           3|Emotional Questions    |T001-006 |
|      81.0|  240.00|            1|           4|Texting                |T001-007 |
|     510.0|  671.00|            1|           4|Texting                |T001-007 |


Data Introduction, Preparation, and Project Management
========================================================

### File Desriptions
  * **Simulation Files**: 509 excel files ranging from 3,000 to 30,000 observations her file. (750MB)
  * **Stimuli Files**: 267 
  * Each simulation includes likelihood scores for 8 facial expressions recorded at a fixed interval of .03 seconds
  * Stimuli data which records targetted events introduced into some of the simulations and basic demographic data on each subject were also available
  * The entire data set was originally stored in 777 individual data files

---

