function [DetectOut Debug] = LEASTSQUARES_Detect(DetectIn, path="Classifiers/")
    % Get inputs from python
	TrialData = DetectIn.("TrialData");
	TrainOut = DetectIn.("TrainOut");
        
        V       = TrainOut.V;
        W       = TrainOut.W;
        Wo      = TrainOut.Wo;
	PC_Num  = TrainOut.PC_Num;
    
    % Add pathes of needed functions
	addpath([path 'Functions']);
	addpath([path 'RawDataFunctions']);
    
    % do pre-processing here please
	noise = mean(TrialData')';
	TrialData =  TrialData -noise;
    
    % Get features (mu & beta)
	[Mu, Beta] = GetMuBeta_detect(TrialData);
    
    % apply LDA method to the features
	Z = [Mu Beta]*real(V);
    
    % apply the classifier here
	Z = Z(:,1:PC_Num);
	y = TrainOut.W'*Z';
	y += Wo;
    
    % getting the class label here 
	Target = "NONE";
	
        if(y > 0) 
            Target = "RIGHT";
	elseif(y < 0)
            Target = "LEFT";
	end
    
    % Debug
	Debug.W = W;
	Debug.pc = PC_Num;
    
    %DetectOut
	DetectOut = Target;
end
