
ConfusionMat = zeros(2,2);
ConfusionMat2 = zeros(2,2);

%do this process a lot for better accuracy
for count = 1:1000
    %generate a random set of values, used to split data into a training
    %and testing matrix
    randomindex = randperm(18,18); 
    for i = 1:12
        trainingconflictmatrix(:,i) = normconflictmatrix(:,randomindex(i));
        trainingnonconflictmatrix(:,i) = normnonconflictmatrix(:,randomindex(i));
    end

    for i = 13:18
        testingmatrix(:,i-12) = normconflictmatrix(:,randomindex(i));
    end

    for i = 13:18
        testingmatrix(:,i-6) = normnonconflictmatrix(:,randomindex(i));
    end

    ccount = 1;
    pcount = 1;
    
    %tends arrays show which media events are most prominent for conflict
    %and peaceful countries relative to the other set
    tendsconflict = zeros(1,20);
    tendspeaceful = zeros(1,20);

    for i = 1:20
        %average event values for conflict and peaceful countries and
        %compute the normalized difference for all events
        avgconflicteventvalues(i) = sum(trainingconflictmatrix(i,:))/20;
        avgnonconflicteventvalues(i) = sum(trainingnonconflictmatrix(i,:))/20;
        normdifference(i) = (avgconflicteventvalues(i)-avgnonconflicteventvalues(i))/(avgconflicteventvalues(i)+avgnonconflicteventvalues(i));
        %positive differences indicate event is more prominent in conflict
        %countries
        if normdifference(i) > 0
            tendsconflict(1,ccount) = normdifference(i);
            tendsconflict(2,ccount) = i;
            ccount = ccount + 1;
        else
            tendspeaceful(1,pcount) = normdifference(i);
            tendspeaceful(2,pcount) = i;
            pcount = pcount + 1;
        end
    end
    
    %sort tendsconflict by largest event values, other row is used to
    %label each event value with the event type
    max = [-100000; 1];
    index = 0;
    sorted = zeros(2,20);
    for k = 1:20
        for p = 1:20
            if tendsconflict(1,p)>max(1,1)
                max = tendsconflict(:,p);
                index = p;
            end
        end
        sorted(:,k) = max;
        tendsconflict(:,index) = [0;0];
        max = [-10000; 1];
    end
    tendsconflict = sorted;
    
    
    %repeat same sorting process for tendspeaceful
    max = [-100000; 1];
    index = 0;
    sorted = zeros(2,20);
    for k = 1:20
        for p = 1:20
            if tendspeaceful(1,p) > max(1,1)
                max = tendspeaceful(:,p);
                index = p;
            end
        end
        sorted(:,k) = max;
        tendspeaceful(:,index) = [-100;-100];
        max = [-10000; 1];
    end
    tendspeaceful = sorted;
        
    %testevents extracts most only most prominent event values for peaceful
    %and conflict states
    testevents = zeros(12,8);
    for i=1:6
        for j=1:4
            %calculate the average of top events from testing set
            topavgconflictevents(j) = avgconflicteventvalues(tendsconflict(2,j));
            topavgpeaceevents(j) = avgnonconflicteventvalues(tendspeaceful(2,20-j+1));
            %calculate normal difference
            normcondiff(j) = (avgconflicteventvalues(tendsconflict(2,j))-avgnonconflicteventvalues(tendsconflict(2,j)))/(avgconflicteventvalues(tendsconflict(2,j))+avgnonconflicteventvalues(tendsconflict(2,j)));
            normpeacediff(j) = (avgconflicteventvalues(tendspeaceful(2,20-j+1))-avgnonconflicteventvalues(tendspeaceful(2,20-j+1)))/(avgconflicteventvalues(tendspeaceful(2,20-j+1))+avgnonconflicteventvalues(tendspeaceful(2,20-j+1)));
            %test events can be thought of having 4 quadrants
            %quadrants correspond to conflict and peaceful countries are
            %for most prominent conflict and peaceful events
            testevents(i,j) = testingmatrix(tendsconflict(2,j),i);
            testevents(i,j+4) = testingmatrix(tendsconflict(2,j),i+6);
            testevents(i+6,j) = testingmatrix(tendspeaceful(2,20-j+1),i);
            testevents(i+6,j+4) = testingmatrix(tendspeaceful(2,20-j+1),i+6);
        end
    end
    
    count = 1;
    
    classificationtotal = zeros(1,12);

    for i = 1:12
        if i<7
            %calculate normalized difference for each event in each
            %quadrant of testevents (realizing now I could have done this
            %process much more simply
            diffnonconflict(i,:) = (topavgconflictevents-testevents(i,1:4))./(topavgconflictevents+testevents(i,1:4));
            diffconflict(i,:) = (testevents(i+6,1:4)-topavgpeaceevents)./(topavgpeaceevents+testevents(i+6,1:4));
            %calculate correlation of the testing data with the average top
            %event values of training set
            corrconflict = corrcoef(topavgconflictevents,testevents(i,1:4));
            corrnonconflict = corrcoef(topavgpeaceevents,testevents(i+6,1:4));
        else
            diffnonconflict(i,:) = (topavgconflictevents-testevents(i-6,5:8))./(topavgconflictevents+testevents(i-6,5:8));
            diffconflict(i,:) = (testevents(i,5:8)-topavgpeaceevents)./(topavgpeaceevents+testevents(i,5:8));
            corrconflict = corrcoef(topavgconflictevents,testevents(i-6,5:8));
            corrnonconflict = corrcoef(topavgpeaceevents,testevents(i,5:8));
        end
        %classification technique one
        %compare correlation with conflict events and peaceful events; if
        %corrconflict is higher, label test country as conflict, otherwise
        %label it as peaceful
        %Create confusion matrix with this data
        if corrconflict(1,2) > corrnonconflict(1,2)
            classification(i) = 0;
 
            if i < 7
                ConfusionMat(1,1) = ConfusionMat(1,1) + 1;
            else
                ConfusionMat(1,2) = ConfusionMat(1,2) + 1;
            end
        else
            classification(i) = 1;
            classificationtotal(i) = classificationtotal(i)+1;
            if i < 7
                ConfusionMat(2,1) = ConfusionMat(2,1) + 1;
            else
                ConfusionMat(2,2) = ConfusionMat(2,2) + 1;
            end
        end
        %for second classification technique 
        %if diffconflict is negative, label country as conflict; otherwise
        %label as peaceful
        if sum(diffconflict(i,:))<0
            classification(i) = 0;
 
            if i < 7
                ConfusionMat2(1,1) = ConfusionMat2(1,1) + 1;
            else
                ConfusionMat2(1,2) = ConfusionMat2(1,2) + 1;
            end
        else
            classification(i) = 1;
            classificationtotal(i) = classificationtotal(i)+1;
            if i < 7
                ConfusionMat2(2,1) = ConfusionMat2(2,1) + 1;
            else
                ConfusionMat2(2,2) = ConfusionMat2(2,2) + 1;
            end
        end
    end
end

%evaluation metrics for model one
accuracy = (ConfusionMat(1,1)+ConfusionMat(2,2))/(ConfusionMat(1,1)+ConfusionMat(1,2)+ConfusionMat(2,1)+ConfusionMat(2,2))
sensitivity = ConfusionMat(1,1)/(ConfusionMat(1,1)+ConfusionMat(2,1))
specificity = ConfusionMat(2,2)/(ConfusionMat(2,2)+ConfusionMat(1,2))
errorrate = 1-accuracy
precision = ConfusionMat(1,1)/(ConfusionMat(1,1)+ConfusionMat(1,2))

%evaluation metrics for model two
accuracy2 = (ConfusionMat2(1,1)+ConfusionMat2(2,2))/(ConfusionMat2(1,1)+ConfusionMat2(1,2)+ConfusionMat2(2,1)+ConfusionMat2(2,2))
sensitivity2 = ConfusionMat2(1,1)/(ConfusionMat2(1,1)+ConfusionMat2(2,1))
specificity2 = ConfusionMat2(2,2)/(ConfusionMat2(2,2)+ConfusionMat2(1,2))
errorrate2 = 1-accuracy2
precision2 = ConfusionMat2(1,1)/(ConfusionMat2(1,1)+ConfusionMat2(1,2))


    