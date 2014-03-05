function TrainOut = LEASTSQUARES_Train(directory, path="Classifiers/")
    % Add pathes of needed functions
	addpath([path 'Functions']);
	addpath([path 'RawDataFunctions']);
    
    % Get Raw Data from the file 
	[data, HDR] = getRawData(directory);
    
    % Intial values
	classes_no = [ getClassNumber(HDR,'RIGHT')  getClassNumber(HDR,'LEFT') ];
    
    % do pre-processing here please 
	noise = mean(data')';
	data =  data -noise;	
    
    % Get features (mu & beta)
	[Mu,Beta] =  GetMuBeta(data, HDR);
    
    % apply LDA method to the features
	X = [Mu Beta];
	[Z, V]  = LDA_fn(HDR.Classlabel, X, classes_no);
    
    % Get the classifier parameters here
	accuracy = leastSquaresResults(Z, HDR.Classlabel);
	[AccSelected, AccIndex] = max(accuracy);
	PC_Num = min(AccIndex);
 	W  = Least_Classifier_Parameters(PC_Num, Z, HDR.Classlabel);
    
    % Returing output structure
	TrainOut.V = V;
	TrainOut.W = W(1:end-1);
	TrainOut.Wo = W(end);
	TrainOut.PC_Num = PC_Num;
end
