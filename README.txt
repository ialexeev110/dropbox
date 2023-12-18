Author Ilya Alexeev

README file describes run_analysis.R script to process accelerometer and gyroscope data. A measurement is considered to be a sequence of 128 sensor temporal data points recorded for a given subject for a given activity individual attempt. Each subject has multiple repetitions of the same activity. Initially mean and std (standard deviation) of each measurement (for each sensor) are calculated and stored in the data frame variable "summary_L". Then this data is reduced by calculating the overall average for a given activity for a given subject (for each sensor). The data is stored in the variable "summary_S". 

The code has to be saved in the directory with the "getdata_projectfiles_UCI HAR Dataset" folder

Code description

lines 1-3: define the directory path variables.

lines 5-11: read subject number and activity vectors for the test group and store them in the “subject_test” and “activity_test” variables respectively.

lines 13-19: same as lines 5-11 but for the train data set.

lines 21-25: combine test and train subject and activity vectors.

lines 27-43: read data from corresponding sensor files, calculate mean and std for each measurement, and store results in the variable “stat_test”. Note, for the “stat_test” variable the rows represent alternating means and standard deviations for 9 sensors, while the columns represent individual measurements.

lines 45-61: same as lines 23-43 but for train data.

lines 63-71: combine test and train matrices in one variable ”summary”, transpose the combined array, add header, and sort by subject number.

lines 73-88: create variable “summary_L” that is effectively the same as “summary” but the activity level code is replaced with a meaningful name.

lines 91-123: reduces data stored in the variable ”summary” by averaging means of all measurements for a given subject and a given activity. No standard deviations are calculated. Activity levels are replaced with meaningful names. Data stored in the variable “summary_S”.

line 121: data stored in the variable “summary_S” saved in text file "Acc_data_summary.txt".
