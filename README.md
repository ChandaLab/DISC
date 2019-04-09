### Installing \begin{figure}[htbp] %  figure placement: here, top, bottom, or page
   \centering
   \includegraphics[width=2in]{example.jpg} 
   \caption{example caption}
   \label{fig:example}
\end{figure}\documentclass[11pt, oneside]{article}   	% use "amsart" instead of "article" for AMSLaTeX format
\usepackage{geometry}                		% See geometry.pdf to learn the layout options. There are lots.
\geometry{letterpaper}                   		% ... or a4paper or a5paper or ... 
%\geometry{landscape}                		% Activate for rotated page geometry
%\usepackage[parfill]{parskip}    		% Activate to begin paragraphs with an empty line rather than an indent
\usepackage{graphicx}				% Use pdf, png, jpg, or eps§ with pdflatex; use eps in DVI mode
								% TeX will automatically convert eps --> pdf in pdflatex		
\usepackage{amssymb}

%SetFonts

%SetFonts


\title{Brief Article}
\author{The Author}
%\date{}							% Activate to display a given date or no date

\begin{document}
\maketitle
%\section{}
%\subsection{}



\end{document}  

DISC is written entirely in MATLAB (using MATLAB2017b). No installation beyond obtaining MATLAB is required. Simply add the DISC folder to your file path. 


### Running DISCO

DISC can be run from the command line of MATLAB via

```
DISC
```

or run outside of the GUI using the runDISC.m function. 

## Authors

David S. White conceived and wrote the DISC algorithm as part of his PhD work at UW-Madison in the labs of Baron Chanda and Randall Goldsmith. Owen Rafferty developed the GUI for running the DISC algorithm.

## Contact 

If you have any questions, comments, or bugs to report, we will do our best to address them. Please contact David S. White at dwhite7@wisc.edu 

## References 

White, D.S., et al., 2019, Manuscript in preparation 

## License 

Currently released under GPLv3

## Acknowledgements 

This project would not be possible without the support of both Dr. Baron Chanda and Dr. Randall H. Goldsmith at UW-Madison. We also thank Dr. Marcel Goldschen-Ohm for helpful feedback on the development of DISC and early GUI code. This project was supported by the NIH grants to B.C (NS-101723, NS-081320, and NS-081293), D.S.W (T32 fellowship GM007507) and R.H.G. (GM127957).


