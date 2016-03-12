# CleaningDataWeek4
Cleaning Data Week 4 Assignment
-------------------------------  
  
##Description:  
Running the function run_analysis results in averages of all the means and std of all the measurements by activity and subject  (grouped by activity and subject).  
  
Based on the data sets of uci:  
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones  
  
##Usage:  
run_analysis(download=TRUE,writetable=true)  
  
##Arguments:  
download&#09;Downloads the data files needed for doing analysis from the uci website, only needed first time
writetable&#09;Writes the output to a textfile with the name averageByActivityAndSubject.txt
  
  
##Examples:   
How to run run_analysis:  
x<-run_analysis(download=TRUE,writetable=true)  
View(x[,c(1:3)])  
  