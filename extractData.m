data = xlsread('DataMiningData.xlsx','A4:BT23');


mat = data(:,2);

for i=2:36
    mat = horzcat(mat,data(:,i*2));
end

usadata = xlsread('results-20170501-082807.csv','A3:A22');
normusa = usadata./sum(usadata);
conflictmatrix = mat(:,1:18);
nonconflictmatrix = mat(:,19:36);

normconflictmatrix = conflictmatrix./sum(conflictmatrix);
normnonconflictmatrix = nonconflictmatrix./sum(nonconflictmatrix);