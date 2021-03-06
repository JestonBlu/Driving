#### Distracted Driving Final Project


This repo is is dedicated to keeping all of the research and analysis related to the final project in my applied statistics masters program at Texas A&M. The data in this project are of 8 driving simulations for 66 individuals ranging from 3,000 to 30,000 observations per simulation. There are over 6.7 million observations in the entire dataset. The data from each simulation includes likelihood scores for 8 facial expressions recorded at a fixed interval of .03 seconds. Stimuli data which records targetted events that were introduced into each simulation and basic demographic data on each subject are also available.

#### Steps to reproducing my work:

The data accompanying this project are too large to host on github. I have created some Python and R scripts for extracting the raw data and combining them for analysis. Since the data are too large you will need to store the data locally and in specific locations to reproduce my results.

**Required Software**
  * Python (Anaconda 2.7 recommended, pandas package required)
  * R (RStudio Recommended for running .Rmd files)

**Extract and Process Raw Data**
  * Execute `python extract_faces.py` from the Files/ folder.
  * Execute `python extract_stimuli.py` from the Files/ folder.
  * The py scripts should produce 2 files in `Files/` (data-faces.csv, data-stimuli.csv).
  * Run `01_data_prep.R`, combines and cleans the 3 data files (`/Files/Other/data-demographics.csv` is the 3rd file)
  * Run `03_data_setup.R`, creates centered and summary level datasets
  * Run `06_data_mdl_setup`, creates training/testing sets

**Reproduce my models**
  * Run `07_model_nnet_best_model.R`, builds my final model
  * Run `07_model_nnet.R`, builds model objects saved to `R-Models`

**Reproduce my written analysis (produces .pdf reports)**
  * `02_processing_and_exploration.Rmd`, data processing and corrections
  * `04_propasal.Rmd`, initial analysis proposal
  * `05_initial_modeling.Rmd`, first pass models on summarised data
  * `07_modeling_nnet.Rmd`, feed forward neural net models on raw data
  * `09_Project_Outline.Rmd`, summary of all work

**Directory location of files needed to extract and process the initial dataset only**
  ```
  Driving/
         |---Files/
                |---Faces/   (509 .xlsx files not on Github)
                |---Stimuli/ (267 .stm files not stored on Github)
                |---Other/   (data-demographics.csv)
                |---extract_faces.py
                |---extract_stimuli.py
                |---data-faces.csv (created by extract_faces.py)
                |---data-stimuli.csv (created by extract_stimuli.py)
         |---R-Scripts/
                |---01_Data_Prep.R
                |---03_Data_Setup.R
         |---R-Data/ (location of RDatasets created by 01_Data_Prep.R)
  ```
