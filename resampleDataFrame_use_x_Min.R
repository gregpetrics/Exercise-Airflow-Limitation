resampleDataFrame_use_x_Min <- function(inputData,resampleN) {
#' Resamples all columns of a numeric dataframe to a specified number of rows.
#' Assumes that columns are pairs of time series.

  #Get rows and columns
  numRows <- nrow(inputData)
  numCols <- ncol(inputData)
  
  #establish empty data frame with "dummy" column temp to set
  #number of columns
  resampledData <- data.frame(tempCol = rep(NA,resampleN))
  
  #stop calculation if number of columns is not divisible by 2
  stopifnot(numCols %% 2 == 0)
  
  for(i in 1:(numCols/2)){
    if(!is.na(inputData[1,2*(i-1)+1])[1]){
      xColToBeResampled <- inputData[ ,2*(i-1)+1][!is.na(inputData[ ,2*(i-1)+1])]
      yColToBeResampled <- inputData[ ,2*(i-1)+2][!is.na(inputData[ ,2*(i-1)+1])]
      
      #resample 
      colResampled <- spline(x = xColToBeResampled,
                             y = yColToBeResampled,
                             xout = seq(min(xColToBeResampled, na.rm = TRUE),
                                        max(xColToBeResampled, na.rm = TRUE),
                                        length.out=resampleN),
                             ties = list("ordered", mean) )
      
      
      colResampled <- data.frame(colResampled)
      
      resampledData <- cbind(resampledData,colResampled)
    }else{
      colResampled <- data.frame(rep(NA,resampleN),
                                 rep(NA,resampleN))
      resampledData <- cbind(resampledData,colResampled)
    }
  }
  
  #Remove dummy column "temp" 
  resampledData <- resampledData[,-1]
  

  #make names same as original 
  names(resampledData) <- names(inputData)
  
  #return result
  return(resampledData)
  
  
}