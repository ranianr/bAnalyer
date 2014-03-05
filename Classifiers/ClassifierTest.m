function ClassifierTest()
    addpath([path 'RawDataFunctions']);
    
    filename = "/media/medo/72d224aa-fdaf-4ffa-8d1f-143d37a80899/home/medo/Work/GP/[2014-02-22] DetectionGUI/TrainingData/[2014-01-15 15-02-52] Mohamed Nour El-Din.csv"
    
    TrainOut = KNN_PCA_Train(filename, "");
    DetectIn.("TrainOut") = TrainOut;
    
    [Data, HDR] = getRawData(filename);
    
    result = [];
    accuracy = 0;
    %loop over data
    
    printMatrix = [];
    
    for h = 1:28
        accuracy = 0;
        DetectIn.("TrainOut").PC_Num = h;
        
        for n = 1:length(HDR.TRIG)-1
            TRIG = HDR.TRIG(n);
            DetectIn.("TrialData") = getTrialData(Data, TRIG);
            [DetectOut Debug] = KNN_PCA_Detect(DetectIn, "");
            
            result = [result getClassNumber(HDR, DetectOut)];
            
            if(getClassNumber(HDR, DetectOut) == HDR.Classlabel(n))
                accuracy+=1;
            end
        end
        
        printMatrix = [printMatrix accuracy];
    end
    
    disp(printMatrix);
end

function TrialData = getTrialData(Data, TRIG)
    trial_start = TRIG;
    trial_end = TRIG + 4*128;
    TrialData = Data(trial_start:trial_end,:)';
end
