function TrainOut = LIKELIHOOD_Train(directory, path="Classifiers/")
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
	accuracy = likelihoodResults(Z, HDR.Classlabel);
	[AccSelected, AccIndex] = max(accuracy)
	PC_Num = min(AccIndex)
	[PI segma mu1 mu2] = Likeli_Classifier_Parameters(PC_Num, Z, HDR.Classlabel);
    
    % Returing output structure
	TrainOut.PI = PI;
	TrainOut.Segma = segma;
	TrainOut.mu1 = mu1;
	TrainOut.mu2 = mu2;
	TrainOut.V = V;
	TrainOut.PC_Num = PC_Num;
end

