import os

#Trained-data, Detected-data and Octave-classifiers folders
TrainingFolder      = os.getcwd() + "/TrainingData"
DetectionFolder     = os.getcwd() + "/DetectionData"
ClassifiersFolder   = os.getcwd() + "/Classifiers"

#Octave functions suffix
TrainSuffix         = "_Train"
DetectSuffix        = "_Detect"

#Print on the terminal
PrintSessionDetails = False      #Enable for RPi, to see the output on the shell
PrintDataStream     = False
PrintDataStream_Rate= 100       #100 = update the screen every 0.1 sec

#Debug
Debug = True