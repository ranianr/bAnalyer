function [DetectOut Debug] = KNN_LDA_Detect(DetectIn, path="Classifiers/")
    % Get inputs from python
	TrialData = DetectIn.("TrialData");
	TrainOut = DetectIn.("TrainOut");
        
        V       = TrainOut.V;
        k       = TrainOut.K;
        Ztrain  = TrainOut.Ztrain;
	PC_Num  = TrainOut.PC_Num;
        ClassLabels = TrainOut.ClassLabels;
        ClassLabels(ClassLabels == 2) = -1;
    
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
        Ztrain = Ztrain(:,1:PC_Num);

    % apply the classifier here
	if(size(Z)(2) == 1)
		Ztrain = [Ztrain, Ztrain];
		Z = [Z, Z];
	end
        
	pointDistance = distancePoints(Z, Ztrain);
        
        distance = pointDistance';
        [dist index1] = sort(distance);
        nearestK = dist(2:k+1);
        nearestPointsIndex = index1(2:k+1);
        Ktargets = ClassLabels(nearestPointsIndex);
        vote = sum(Ktargets);
        Yp = 0;%add else error = error +1
        
        if(vote > 0)
            Targets =  'RIGHT';
        elseif(vote < 0)
            Targets = 'LEFT';
        else 
            single_target = ClassLabels( distance == min(distance(2:k+1)));
            if(single_target > 0)
                Targets =  'RIGHT';
            else
                Targets = 'LEFT';
            end
        end
    
    % Debug
	Debug = vote;
    
    %DetectOut
	DetectOut = Targets;
end