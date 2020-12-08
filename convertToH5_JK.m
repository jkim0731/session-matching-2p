function [] = convertToH5_JK(sessionName,targetDir)
% from 'convertToH5', add 'targetDir' to save the image in a different disk
% drive
% 2020/11/29 JK

    if ~strcmp(targetDir(end), '\')
        targetDir = [targetDir,'\'];
    end
    
    % session name definition
    sessionID = strsplit(sessionName, '\');
    sessionID = sessionID{end};

    % for a given session load the trials
    trials = importdata([sessionName '.trials']);
    load([sessionName, '.mat'], 'info')
    
    % vars
    nPlanes = length(trials.frame_to_use);
    yStart = round(optotune_ringing_time/ (1000/info.resfreq) *(2-info.scanmode));
    xStart = 100;
    xDeadband = 10;

    framePlanes = trials.frame_to_use; % 2020/12/02 JK

    % extract frames for each plane and save
    for i = 1:nPlanes
%     for i = 6:nPlanes
       planeDir = fullfile(targetDir, ['plane_' num2str(i)]);
       mkdir(planeDir);
       planeFile = fullfile(planeDir, [sessionID, '_plane_', num2str(i), '.h5']);

       % load
       q = squeeze(jksbxreadframes(sessionName, framePlanes{i}, 1));
       q = q(yStart:end, xStart : end-xDeadband, :);

       % save
       h5create(planeFile, '/data', [size(q, 1), size(q, 2) length(framePlanes{i})], 'DataType', 'uint16', 'ChunkSize',[size(q,1) size(q,2) 1])
       h5write(planeFile,'/data',q)       
    end
end

