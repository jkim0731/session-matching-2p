clear all; close all; clc;

sessions = {'E:\027\027_000_000',...
            'E:\027\027_003_000',...
            'E:\027\027_006_000',...
            'E:\027\027_009_000',...
            'E:\027\027_012_000',...
            'E:\027\027_015_000'};
        
nSessions = length(sessions);
nPlanes = 8;
        
%% load framePlanes for each session
framePlanes = cell(1, nSessions);
nFrames = nan(nSessions, nPlanes);
for s = 1:nSessions
    fp = load(fullfile(sessions{s}, 'framePlanes.mat'));
    framePlanes{s} = fp.framePlanes;
    
    nFrames(s, :) = cellfun(@length, framePlanes{s});
end

%% load combined session fluorescence (plane n)
plane = 4;
fall = load(fullfile(sessions{1}, ['plane_' num2str(plane)], 'suite2p', 'plane0', 'Fall.mat'));
fs = fall.ops.fs;

%% plot fluorescence and divide up by session
goodCellIdx = find(fall.iscell(:, 1) == 1);
F = fall.F(goodCellIdx, :);
Fneu = fall.Fneu(goodCellIdx, :);
nCells = size(F, 1);

% conditiohn fluorescence
Fc = F;
figure; hold on;
for i = 1:50
    Fc(i,:) = F(i,:) - (Fneu(i,:)*0.7);
    
    plot(Fc(i,:) - (i*10000), 'k')
end

sessionMarker = cumsum(nFrames(:,plane))';
for s = 1:length(sessionMarker)
   plot([sessionMarker(s), sessionMarker(s)], [0 (-i*10000)], 'b--'); 
end

ylim([-(i*10000)-10000 10000])

%% activity epochs over sessions for each cell
sessionIdx = [1 sessionMarker];
constantActive = zeros(1, nCells);
figure;
for i = 1:nCells
    sessionFreq = nan(1,nSessions);
    [pks, locs] = findpeaks(Fc(i,:), 'MinPeakProminence', 2000);
    plot(Fc(i,:)); hold on;
    scatter(locs, pks, 'b'); hold off;
    
    for s = 2:length(sessionIdx)
        [pks, locs] = findpeaks(Fc(i,sessionIdx(s-1):sessionIdx(s)), 'MinPeakProminence', 2000);
        sessionFreq(s-1) = length(locs) / length(sessionIdx(s-1):sessionIdx(s));
    end
    if all(sessionFreq>0.01)
        constantActive(i) = 1;
    end
end

constActiveROIs = goodCellIdx(constantActive==1);

%% show mean cell image for each session for constantly active ROIs
roi = constActiveROIs(5);
roiPos = fall.stat{roi}.med;
window = 20;

registeredBinaryFile = fullfile(sessions{1}, ['plane_' num2str(plane)], 'suite2p', 'plane0', 'data.bin');
sessionStartIdx = sessionIdx(1:end-1);
Ly = fall.ops.Ly;
Lx = fall.ops.Lx;
nImg = 1000;
meanCells = [];

fid = fopen(registeredBinaryFile, 'r');

while 1
    data = fread(fid, Ly*Lx*nImg, '*int16');
    data = reshape(data, Lx, Ly, []);
    
    if isempty(data)
       break; 
    end
    
    cellWindow = data((roiPos(2)-window):(roiPos(2)+window),(roiPos(1)-window):(roiPos(1)+window),:);
    meanCells = [meanCells uint16(mean(cellWindow, 3))];
end

fclose(fid);

figure;
imshow(meanCells);
