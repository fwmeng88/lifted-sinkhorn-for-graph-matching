function [ A,B,n,X_GT,err_GT ] = get_QAPLIB_data( file_path,file_path_GT )
%GETWFROMQAPLIB Summary of this function goes here
%   Detailed explanation goes here
[~,VAR,~] = fileparts(file_path);
data = load(file_path);
data = data.(VAR);
flag_GT = true;

try
    GT = importdata(file_path_GT);
catch 
    flag_GT = false;
    err_GT = 0;
    X_GT = 0;
end
n = data(1,~isnan(data(1,:)));
n = n(1);    

data = data(2:end,:);
[N_length,~] = size(data);
% row number do not match dimasion
A = zeros(n);
B = zeros(n);
s = 0;
flagA = true;
flagB = false;
counter = 0;
row = [];
s = 0;
for i = 1:N_length
    row  = [row,data(i,~isnan(data(i,:)))];
    s = s +sum(~isnan(data(i,:)));
    if (s == n) && flagA
        counter = counter + 1;
        A(counter,:) = row;
        row = [];
        s = 0;
    end
    
    if (s == n) && flagB
        counter = counter + 1;
        B(counter - n,:) = row;
        row = [];
        s = 0;
    end
    
    if counter == n
        flagA = false;
        flagB = true;
    end    
end

if flag_GT
    if isstruct(GT)
         Dstr = strsplit(GT.textdata{1});
         err_GT = str2num(Dstr{2});
         GT = GT.data;
    else
        err_GT = GT(1,2);
        GT = GT(2:end,:);
    end
    Ind_GT = [];
    for i = 1:size(GT,1)
        Ind_GT = [Ind_GT,GT(i,~isnan(GT(i,:)))];
    end
    if sum(Ind_GT == 0)>0
        Ind_GT = Ind_GT + 1;
    end
    X_GT = zeros(n);
    for i = 1:n
        X_GT(i,Ind_GT(i)) = 1;
    end
end

end

