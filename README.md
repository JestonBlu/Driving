### Reproducible Research

The data accompanying this project are too large to host on github. I have created some Python and R scripts for extracting the raw data and combining them for analysis. Since the data are too large you will need to store the data locally and in specific locations to reproduce my results. The following is the mimnimal layout you will need to create the combined dataset.

```
Driving/
       |---Files/
              |---Faces/   (.xlsx files not on Github)
              |---Stimuli/ (.stm files not stored on Github)
              |---Other/   (Subject Biographic Info.csv)
              |---extract_faces.py
              |---extract_stimuli.py
       |---R-Scripts/
              |---01_Data_Prep.R
       |---Driving.Proj (RStudio Project File, not on Github)
```

#### Prereqs
  1. Install Python (Anaconda 2.7 recommended, pandas package required)
  2. Install R

#### Steps:
  1. Execute `python extract_faces.py` from the Files/ folder.
  2. Execute `python extract_stimuli.py` from the Files/ folder.
  3. The py scripts should produce 2 files (data_faces.csv, data_stimuli.csv).
  4. If you have an Rstudio Project File in the home project file then source `01_Data_Prep.R`, otherwise you will first need to set the working directory for home directory of the Project
