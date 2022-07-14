# Exercise-Airflow-Limitation
Implements a data tidying and convolutional neural network (CNN) training regimine on the provided Excel example data to learn to classify flow limitation as a response to forced exhilation ventilation loops (FEVLs). 

The provided Excel files, JC_data_tidied_forR.xlsx and RK_data_tidied_forR.xlsx, demonstrate the needed data format in which each column is a FEVL, the first row of which is the label (AKA classification) of the presence of airflow limitation (0 = not flow limited; 1 = flow limited).

Phase01_DataTidyingAndPrepforCNN.R performs a data tidying task in R of the provided Excel files to prep for CNN training, and exports the tidied data to CSV. 

Phase02_TrainCNN.ipynb is a python notebook that intakes the CSV file, and implements a machine learning training protocol to train a CNN to learn the labels as a response to the FEVL. Assessment of the skill of the model is also performed in this notebook.

A user interested in replicating this process should format their data as demonstrated in JC_data_tidied_forR.xlsx and RK_data_tidied_forR.xlsx and then adjust the appropriate line in Phase01_DataTidyingAndPrepforCNN.R.

