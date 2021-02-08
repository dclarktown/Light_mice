# Read Me
This depository contains the data and code for the "Light Environment Influences Developmental Programming of the Metabolic and Visual Systems in Mice" paper. 

# Data

Figure 2: female activity data 
- The "ActogramJ_data" file contains the PIR data and the "wheel_CD" file contains the wheel running data that were read into ActogramJ to create the actograms. 
- The same PIR data that was used for the actograms was used for the nparACT analysis for IS, IV and RA (code and data below). 
- NOTE: actigraphy data is from cages of female C57 mice (n=2-4/cage), all fed standard chow diet except for F3_CL, fed CON diet

Figure 3: dam serum data
- The serum data is available in the "Dam_serum_data" file.

Figures 4-8, Supplemental Figures 1-2: longitudinal data
- All of the longitudinal data (weekly weight, weekly blood glucose, GTT, OMR, ERG) is available in the "Data_masterfile" file.
- The WK4, WK8, WK12, WK16, and WK20 blood glucose data is fasted (all other weeks are non-fasted), and is the same value as the "BG_0" (baseline) value from the glucose tolerance test for that timepoint.
- For the GTT data, "BG_0", denotes blood glucose at time 0 (baseline), "BG_15" at 15 minutes after injection, and so on. 
- For the OMR data, columns end with "L", "R" or "C" and denote the eye (left, right, combined); the paper presents the combined eye data ("C).
- NOTE: for the ERG data, the data columns are labeled with an X in front; for example, "X1BAmp_WK13" would be the first (X1) flash intensity step (-2.5 log cd/m2) with the B wave amplitudes (Bamp) at 13 weeks of age (WK13); X2 would be the next flash intensity (-1.9 log cd/m2), and so on. Similarly, flicker data is X6. The green cone data from week 21 has its own columns, such as "WK21_greencone_B_Amp". 
- The data used to generate the representative waveforms in the ERG figures are available in the "example_waveforms_wk9" file, the "wk9_flicker_waveforms_csv" file, and the "example_OP2_waveforms_wk9" file.

Figure 9, Supplemental Figure 3: retinal immunofluorescence data - Cd11b and Iba1 staining
- The quantified immunofluorescence data that was used for the analysis in Figure 9 is available in the "IHC_data" file.

# Code

The statistical analyses were performed in GraphPad Prism and R. Some example R code to run statistical analyses and plot the ERG example waveforms is provided in the "R_code" file, with the corresponding "Data_masterfile_FIN.RData" dataset. 

The R code used to generate the IS, IV, and RA actigraphy data is available in the "R_code_nparACT" file with corresponding "nparACT.RData" file. The graphed output data is available in the "nparACT_output" file.
