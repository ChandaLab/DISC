# Divisive Segmentation and Clustering (DISC)

## Welcome to DISC! 

DISC is an open source MATLAB package for time series idealization (i.e. identifying significant states and transitions). We enhance change-point detection using divisive clustering to accelerate the typical speed of time-trajectory analysis by orders of magnitude with improved accuracy. We have designed the DISC framework to be a flexible approach, with applications primarily in single-molecule data, such as smFRET and force spectroscopy. The full details of this work are described in our recent manuscript which we ask you to kindly cite if using this software: 

White, D., Goldschen-Ohm, M., Goldsmith, R. & Chanda, B. High-Throughput Single-Molecule Analysis via Divisive Segmentation and Clustering. bioRxiv, 603761 (2019).


## DISCO

DISCO is the graphical user interface (GUI) for DISC. We aimed to make DISCO as user friendly as possible and welcome feedback on how we can improve. Please see the provided DISC_user_manual.pdf for full instructions. As DISCO gains more use, we can make other requested features available (i.e. dwell time analysis, automated trace selection, etc...). All updates will be made available on https://github.com/ChandaLab/DISC pending manuscript acceptance. Stay tuned!

### Installation 

DISC is written entirely in MATLAB (using MATLAB2017b or later). No installation beyond obtaining MATLAB is required. The MATLAB Statistics and Machine Learning Toolbox is required.  

### System Requirements 

To our knowledge, as long as your system is capable of running MATLAB (2017b or later), running DISC should not be a problem. DISC (and DISCO) have been tested on: 

1. Linux
2. MacOS 
3. Windows 

### Running DISCO

Add the DISC folder to your file path. DISC can be run in a GUI from the command line of MATLAB via

```
DISCO
```

or run outside of the GUI using the runDISC.m function. See DISC_user_manual.pdf for more information. 


### Demo

A sample set of simulated data is provided /sample_data/sample_data.mat. True values of simulation results are provided within this sample. This analysis took < 10 seconds to complete on a personal MacBook Air (1.6 GHz Intel Core i5) in MATLAB 2018b. Detailed instructions for analyzing this sample to reproduce these results are provided in DISC_user_manual.pdf with the analysis results found in sample_data/sample_data_idealized.mat.

We've also provided the same data in plain text (.dat) format, in full (sample_data/sample_data.dat) and truncated (sample_data/sample_data_truncated.dat) forms, the latter for readability. These files are formatted in the same fashion as [HaMMy](http://ha.med.jhmi.edu/resources/#1464200861600-0fad9996-bfd4).

### Simulate Data

All scripts used for the simulations in White et al.,2019 can be found in /simulate_data. Running runSimulations.m as is will generate simulated data with identical conditions to those used in the manuscript. Calculation of accuracy, precision, and recall of DISC performance on simulated data was completed using idealizationMetrics.m

### Reproducibility 

All data sets in White et al., 2019 both simulated and raw were analyzed using runDISC.m or DISCO.m with the following parameters: 

1. alpha_value = 0.05 for change point detection 
2. BIC_GMM for both divisive and agglomerative clustering
3. 1 iteration of the Viterbi algorithm

These are the default values in both runDISC.m and DISCO.


## Authors

David S. White conceived and wrote the DISC algorithm as part of his PhD work at UW-Madison in the labs of Baron Chanda and Randall Goldsmith. Owen Rafferty contributed to the development of the GUI for running the DISC algorithm.

## Contact 

If you have any questions, comments, or bugs to report, we will do our best to address them. Please email David S. White at dwhite7@wisc.edu 

## References 

White, D., Goldschen-Ohm, M., Goldsmith, R. & Chanda, B. High-Throughput Single-Molecule Analysis via Divisive Segmentation and Clustering. bioRxiv, 603761 (2019).

## License 

Currently released under GPLv3

## Acknowledgements 

This project would not be possible without the support of both Dr. Baron Chanda and Dr. Randall H. Goldsmith at UW-Madison. We also thank Dr. Marcel Goldschen-Ohm for helpful feedback on the development of DISC and early GUI code. This project was supported by the NIH grants to B.C (NS-101723, NS-081320, and NS-081293), D.S.W (T32 fellowship GM007507) and R.H.G. (GM127957).


