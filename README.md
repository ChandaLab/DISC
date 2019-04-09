# Divisive Segmentation and Clustering (DISC)


## Welcome! 

DISC is an open source (GNU license)  MATLAB package for  time series idealization (i.e. identifying significant states and transitions). We enhance change-point detection algorithms with divisive clustering scheme to accelerate the typical speed of time-trajectory analysis by orders of magnitude while retaining or improving accuracy. We have designed the DISC framework to be a flexible approach, with applications primarily in single-molecule data, such as smFRET and force spectroscopy. The full details of this work are described in “High-Throughput Single-Molecule Analysis via Divisive Segmentation and Clustering (manuscript in preparation)”. 

Our graphical user interface (GUI) was designed to be as user friendly as possible and we welcome feedback on how we can improve. Please see DISC_user_manual.pdf for full instructions. As DISC gains more use, we can make other requested features available. All updates will be made available on https://github.com/ChandaLab/DISC. 


### Installing 

DISC is written entirely in MATLAB (using MATLAB2017b). No installation beyond obtaining MATLAB is required. Simply add the DISC folder to your file path. 


### Running DISCO

DISC can be run from the command line of MATLAB via

```
DISC
```

or run outside of the GUI using the runDISC.m function. Within the DISC GUI, data can be loaded and saved under file->load / file-> save.

## Authors

David S. White conceived and wrote the DISC algorithm as part of his PhD work at UW-Madison in the labs of Baron Chanda and Randall Goldsmith. Owen Rafferty developed the GUI for running the DISC algorithm.


### Contact 

All questions and comments pertaining to the use of DISC should be addressed to David S. White at dwhite7@wisc.edu

## References 

White, D.S., et al., 2019, Manuscript in preparation 

## Acknowledgements 

This project would not be possible without the support of both Dr. Baron Chanda and Dr. Randall H. Goldsmith at UW-Madison. We also thank Dr. Marcel Goldschen-Ohm for helpful feedback on the development of DISC and early GUI code. This project was supported in part by the N.I.H. (T32 GM007507 to D.S.W. and 1R01NS101723-01 to B.C.).


