# Read Me
This depository contains the data and code for the "Light Environment Influences Developmental Programming of the Metabolic and Visual Systems in Mice" paper. 

# Data

Figure 2: female activity data 
- The "ActogramJ_data" file contains the PIR data and the "wheel_CD" file contains the wheel running data that were read into ActogramJ to create the actograms. 
- The activity count data to compare activity during light cycles is available in the "Count_data_total" file.
- The same PIR data that was used for the actograms was used for the nparACT analysis and activity count data by light cycle and is available in the "counting_activity_light_dark_cycles" file. 

Figure 3: dam serum data
- The serum data is available in the "Dam_serum_data" file.

Figures 4-8, Supplemental Figures 2-3: longitudinal data
- All of the longitudinal data (weekly weight, weekly blood glucose, GTT, OMR, ERG) is available in the "Data_masterfile" file.
- For the GTT data, "BG_0", denotes blood glucose at time 0 (baseline), "BG_15" at 15 minutes after injection, and so on. 
- For the OMR data, columns end with "L", "R" or "C" and denote the eye (left, right, combined); the paper presents the combined eye data ("C).
- NOTE: for the ERG data, the data columns are labeled with an X in front; for example, "X1BAmp_WK13" would be the first (X1) flash intensity step (-2.5 log cd/m2) with the B wave amplitudes (Bamp) at 13 weeks of age (WK13); X2 would be the next flash intensity (-1.9 log cd/m2), and so on. Similarly, flicker data is X6. The green cone data from week 21 has its own columns, such as "WK21_greencone_B_Amp". 
- The data used to generate the representative waveforms in the ERG figures are available in the "example_waveforms_wk9" file, the "wk9_flicker_waveforms_csv" file, and the "example_OP2_waveforms_wk9" file.

Supplemental Figure 1: diet activity data

# Code

The statistical analyses were performed in GraphPad Prism and R. Some example R code to run statistical analyses and plot the ERG example waveforms is provided in the "R_code" file, with the corresponding "Data_masterfile_FIN.RData" dataset. 

The code used to sum the activity data (in the "Count_data_total" file) is available in the "R_code_actigraphy" file. The R code used to generate the IS, IV, and RA actigraohy data is available in the "R_code_nparACT" file with corresponding "nparACT.RData" file. 
