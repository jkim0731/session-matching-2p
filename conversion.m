clear all; close all; clc;
            
sessionNames = {'E:/027/027_015_000',...
                'E:/027/027_018_000',...
                'E:/027/027_021_000',...
                'E:/027/027_024_000'};
            
for s = 1:length(sessionNames)
   disp(['session: ' num2str(s)]);
   convertToH5(sessionNames{s}); 
end