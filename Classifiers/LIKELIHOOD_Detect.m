function [DetectOut Debug] = LIKELIHOOD_Detect(DetectIn, path="Classifiers/")
    % Get inputs from python
	TrialData = DetectIn.("TrialData");
	TrainOut = DetectIn.("TrainOut");
        
        PI = TrainOut.PI;
	segma = TrainOut.Segma;
	mu1 = TrainOut.mu1;
	mu2 = TrainOut.mu2;
	V = TrainOut.V;
	PC_Num = TrainOut.PC_Num;
    
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
	Z = Z(:,1:PC_Num);
    
    % apply the classifier here
	N1 = PI;
	N2 = 1-PI;
	P_comparison = [];
        
	for s = 1:size(Z)(1)
            P_XgivenC1_expTerm1 = -0.5*(Z(s,:)-mu1')*(inv(segma))*(Z(s,:)-mu1')' ;
            P_XgivenC2_expTerm2 = -0.5*(Z(s,:)-mu2')*(inv(segma))*(Z(s,:)-mu2')' ;
            ModifiedClass1_Ratio = log(N1/N2) + (P_XgivenC1_expTerm1 - P_XgivenC2_expTerm2);
            ModifiedClass2_Ratio = log(N2/N1) + (P_XgivenC2_expTerm2 - P_XgivenC1_expTerm1); 
            P_comparison = [P_comparison; ModifiedClass1_Ratio > ModifiedClass2_Ratio];
	end
	
	if(P_comparison == 1)
            Target = 'RIGHT';
	elseif(P_comparison == 0)
            Target = 'LEFT';
	end
    
    % Debug
	Debug = [P_XgivenC1_expTerm1, P_XgivenC2_expTerm2]
    
    %DetectOut
	DetectOut = Target;
end