clear all; close all; clc;

sessionNames = {'E:/025/025_007_000'};

for s = 1:length(sessionNames)
   disp(['session: ' num2str(s)]);
   convertToH5(sessionNames{s}); 
end 