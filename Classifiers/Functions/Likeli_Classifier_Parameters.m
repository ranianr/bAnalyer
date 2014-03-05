function [PI segma mu1 mu2] = Likeli_Classifier_Parameters(PC_Num, projected, targets)
    projected = real(projected)';
        C1=[];
        C2=[];
        
        for k = 1:(PC_Num)
            C1 = [ C1 ; projected(k, :)(targets==1)];
            C2 = [ C2 ; projected(k, :)(targets==2)];
        end     
        t = [ones(size(C1)(2),1) ; -1*ones(size(C2)(2),1)];
        dataTotal = [C1,  C2]';
        [PI, segma, mu1, mu2] = likelihood_train(dataTotal, t);

end

