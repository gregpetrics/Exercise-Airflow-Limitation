infillNAColumns <- function(inputData) {
  #' infills NA columns by averaging data left and right of a resampled data frame.
  #' it is strongly advised to run resampleDataFrame() first to ensure all columns are of same
  #' length.
  
  #Get rows and columns
  numRows <- nrow(inputData)
  numCols <- ncol(inputData)
  
  #stop calculation if number of columns is not divisible by 2
  stopifnot(numCols %% 2 == 0)

  for(i in 2:(numCols/2)-1){
    if(is.na(inputData[1,2*(i-1)+1])[1]){
      j=1
      while(is.na(inputData[1,2*(i-1+j)+1][1])) {
        j <- j+1
      }
      inputData[,2*(i-1)+1] <- (j*inputData[,2*(i-2)+1]+inputData[,2*(i-1+j)+1])/(j+1)
      inputData[,2*(i-1)+2] <- (j*inputData[,2*(i-2)+2]+inputData[,2*(i-1+j)+2])/(j+1)
    }
  }
  return(inputData)
}
  