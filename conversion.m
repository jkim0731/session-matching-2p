clear all; close all; clc;

baseDir = 'E:\';
mouse = 25;
sessions = [7];

elapsedTimes = zeros(length(sessions),1);

targetBD = 'E:\025\';
%%
parfor si = 1 : length(sessions)
    tic
    sbxList = ls(sprintf('%s%03d\\%03d_%03d_0*.sbx',baseDir,mouse,mouse,sessions(si)));
    for sbxi = 1 : size(sbxList,1)
        sbxFn = sbxList(sbxi,1:end-4); % removing '.sbx'
        fn = sprintf('%s%03d\\%s',baseDir,mouse,sbxFn);
        if sessions(si) > 1000 % spontaneous or piezo sessions
            laserOnFrames = laser_on_frames(fn);
            jksbxsplittrial_4h5c(fn,laserOnFrames)
        else
            jksbxsplittrial_4h5c(fn) % run this again, making .trial files
        end
        optotuneRingingTime = 8; % in ms. To crop top portion of each frame.

        targetDir = sprintf('%s%03d\\',targetBD,mouse);
        convertToH5_JK(fn,targetDir,optotuneRingingTime)
    end
    elapsedTimes(si) = toc;
end

%% Check frame index
% baseDir = 'P:\';
% mouse = 38;
% sessions = [16:31,5554,5555,9998,9999];
% maxIdx = zeros(length(sessions),2); %(:,1) from .trials, (:,2) from sbx_maxidx
% % for si = 1 : length(sessions)
% for si = 17  
%     sbxList = ls(sprintf('%s%03d\\%03d_%03d_0*.sbx',baseDir,mouse,mouse,sessions(si)));
%     for sbxi = 1 : size(sbxList,1)
%         sbxFn = sbxList(sbxi,1:end-4); % removing '.sbx'
%         fn = sprintf('%s%03d\\%s',baseDir,mouse,sbxFn);
% %         if sessions(si) > 1000 % spontaneous or piezo sessions
%             laserOnFrames = laser_on_frames(fn);
%             jksbxsplittrial(fn,laserOnFrames)
% %         else
% %             jksbxsplittrial(fn) % run this again, making .trial files
% %         end
%         
%         trials = importdata([fn,'.trials']);
%         maxIdx(si,1) = max(cellfun(@max, trials.frame_to_use));
%         maxIdx(si,2) = sbx_maxidx(fn);
%     end
% end