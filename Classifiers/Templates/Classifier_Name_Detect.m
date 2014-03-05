function [DetectOut Debug] = Test_Detect(DetectIn, path="Classifiers/")
    % Get inputs from python
	TrialData = DetectIn.("TrialData");
	TrainOut = DetectIn.("TrainOut");
    
    % Add pathes of needed functions
	addpath([path 'Functions']);
	addpath([path 'RawDataFunctions']);
    
    % do pre-processing here please
	noise = mean(TrialData')';
	TrialData =  TrialData -noise;
    
    % Get features (mu & beta)
	[Mu,Beta,nChannels] = Getfft(TrialData, HDR);

    % apply LDA method to the features
	Z = [Trials_Mu Trials_Beta]*real(V);
    
    % apply the classifier here
	y= TrainOut.W'*Z;
    
    % getting the class label here 
	y(y>0) = 1;
	y(y<0) = 2;
	
	DetectOut = y;
end