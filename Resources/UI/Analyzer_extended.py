import os
import sys
from TrainingFileClass import TrainingFileClass
from PyQt4 import *
from PyQt4 import QtCore, QtGui
from Analyzer import Ui_MainWindow
import oct2py 
import thread

from ClassifiersClass import Classifiers
from EEGConnectorClass import EEGConnector
from DetectorClass import Detector

import AppConfig

class Ui_MainWindow_Extended(Ui_MainWindow):
    def InitializeUI(self):
    #Training-Files and Scripts ComboBoxes
	self.addComboBoxesData()
	self.path=""
        
	#EVENTS
	QtCore.QObject.connect(self.train_button, QtCore.SIGNAL(("clicked()")), self.TrainButton_Clicked) #train button
	QtCore.QObject.connect(self.browse_button, QtCore.SIGNAL(("clicked()")), self.getFileName) #browse button


    def getFileName(self):
        self.fileDialog = QtGui.QFileDialog()
        self.path = self.fileDialog.getOpenFileName()
        print(" File Selected: ", self.path)
	if(self.csv_rb.isChecked()):
	    self.filePath_txt.setText(self.path)
	    self.XmlFileName = self.path
	    #read CSV files GDF files will be supported later
	    Details = {}
	    TrainingFileClass.getClasses(self.path)
	    Details["SubjectName"]          = TrainingFileClass.getName(self.path)
	    Details["Classes"]              = TrainingFileClass.getClasses(self.path)
	    self.subject_name.setText(Details["SubjectName"]) #subject name label
	elif(self.gdf_rb.isChecked()):
	    pass
	else:#el 7etta deh m7taga ttzbat shewaya ! 
	    self.subject_name.setText("please select file type")
	    self.filePath_txt.setText("please select file type")
	
    
    def addComboBoxesData(self):
        
	self.featureSelectionMethods = ("FFT","PCA","LDA","CSP") #add methods manually !

	self.featureSelection_box.clear()
	self.featureSelection_box.addItems(self.featureSelectionMethods)
	
	#classifiers files
	self.classifiers = ("FIsher","KNN","Likelihood","LeastSquares") #add classifiers manually !
	self.classifierSelection_box.clear()
	self.classifierSelection_box.addItems(self.classifiers )
	
    def TrainButton_Clicked(self):
	
	featureExtractionmeFile = str (self.featureSelection_box.currentText())
	classifierFile = str (self.classifierSelection_box.currentText())
	
	#call the noise removal function
	if(self.removeNoise_cb.isChecked()):
            self.readThread = readDataThread(self.path)
	    QtCore.QObject.connect(self.readThread, QtCore.SIGNAL(("detected(PyQt_PyObject)")), self.cleanData) #thread is done
	    QtCore.QObject.connect(self.readThread, QtCore.SIGNAL(("detected2(PyQt_PyObject)")), self.selectFeatures) #thread is done
	    QtCore.QObject.connect(self.readThread, QtCore.SIGNAL(("detected3(PyQt_PyObject)")), self.classifyData) #thread is done

	    self.readThread.start()

    def cleanData(self, data):
	print(data)
	self.done1.setText("Done!")
	self.readThread.terminate()

    def selectFeatures(self, data):
	print(data)
	self.done2.setText("Done2!")
	self.readThread.terminate()

    def classifyData(self, data):
	print(data)
	self.done3.setText("Done3!")
	self.readThread.terminate()

class readDataThread(QtCore.QThread):
    def __init__(self,  dataFile):
        QtCore.QThread.__init__(self)
	self.dataFile = dataFile
	print(self.dataFile)
	print(self.dataFile)
	print("hiiiiii!!!!!!!")

        #write the initialization here

    def run(self):
        #do what you want here
	octave = oct2py.Oct2Py()
	octave.addpath('Classifiers/RawDataFunctions')
	data = {}
	print(self.dataFile)
	print(type(self.dataFile))
	
        data["Data"], data["HDR"] = octave.call('getRawData.m', str(self.dataFile))
	print(data["Data"])
	print(type(data["Data"]))
	
	cleanData = octave.call('remove_noise.m',data["Data"])
	
        self.emit( QtCore.SIGNAL('detected(PyQt_PyObject)'), data)
        self.emit( QtCore.SIGNAL('detected2(PyQt_PyObject)'), data)
	
        #when you finish, emit	
        self.emit( QtCore.SIGNAL('detected3(PyQt_PyObject)'), data)
	
    
   
    
    
