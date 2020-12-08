clear all; close all; clc;
            
% sessionNames = {'E:/027/027_015_000',...
%                 'E:/027/027_018_000',...
%                 'E:/027/027_021_000',...
%                 'E:/027/027_024_000'};

% sessionNames = {'E:/025/025_012_000',...
%                 'E:/025/025_015_000',...
%                 'E:/025/025_018_000'};

sessionNames = {'E:/025/025_019_000'};
            
for s = 1:length(sessionNames)
   disp(['session: ' num2str(s)]);
   convertToH5(sessionNames{s}); 
end