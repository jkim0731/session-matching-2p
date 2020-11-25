clear all; close all; clc;

% reference image correlations between two sessions
sessions = {'E:/027/027_000_000',...
            'E:/027/027_003_000',...
            'E:/027/027_006_000',...
            'E:/027/027_009_000',...
            'E:/027/027_012_000',...
            'E:/027/027_015_000'};
nSessions = length(sessions);
nPlanes = 8;

%% load reference images
sessionImg = cell(1, nSessions);
for s = 1:nSessions
    sessionImg{s} = cell(1, nPlanes);
    for p = 1:nPlanes
        sessionImgFile = dir([sessions{s} '/plane_' num2str(p) '/*.tiff']);
        sessionImg{s}{p} = imread(fullfile([sessions{s} '/plane_' num2str(p)], sessionImgFile.name));
    end
end

figure;
c = 1;
for p = 1:nPlanes
   for s = 1:nSessions
       subplot(nPlanes, nSessions, c);
       imshow(sessionImg{s}{p});
       c = c+1;
   end
end

%% construct correlation map
figure;
c = 1;
for s1 = 1:nSessions
    for s2 = 1:nSessions
       subplot(nSessions, nSessions, c);
       
       % correlation session s1 vs. sessions s2
       corrMap = nan(nPlanes, nPlanes);
       for i = 1:nPlanes
          for j = 1:nPlanes
             corrMap(i, j) = corr2(sessionImg{s1}{i}, sessionImg{s2}{j}); 
          end
       end
       
       % convert correlation to max map
       maxMap = corrMap;
       for i = 1:nPlanes
           row = corrMap(i,:);
           maxRow = max(row);
           row(row<maxRow) = 0;
           maxMap(i,:) = row;
       end
       
       imagesc(maxMap);
       set(gca, 'YDir', 'normal');
       title(['S1: ' num2str(s1) ' -- S2: ' num2str(s2)])
       
       c = c+1;
    end
end

% %% construct correlation map
% corrMap = nan(nPlanes, nPlanes);
% for i = 1:nPlanes
%    for j = 1:nPlanes
%        R = corr2(sessionImg{1}{i}, sessionImg{2}{j});
%        corrMap(i, j) = R;
%    end
% end
% 
% figure;
% subplot(1,2,1)
% imagesc(corrMap);
% set(gca, 'YDir','normal');
% 
% maxMap = corrMap;
% for i = 1:nPlanes
%     row = corrMap(i,:);
%     maxRow = max(row);
%     row(row<maxRow) = 0;
%     maxMap(i,:) = row;
% end
% 
% subplot(1,2,2);
% imagesc(maxMap);
% set(gca, 'YDir','normal');


