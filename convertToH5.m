function [] = convertToH5(sessionName)
    % session name definition
    sessionID = regexp(sessionName, '/', 'split');
    sessionID = sessionID{end};

    % for a given session load the trials
    trials = importdata([sessionName '.trials']);
    % and meta info
    meta = load([sessionName '.mat']);

    % vars
    nPlanes = length(trials.frame_to_use);

    % for this session, what are the first and last frames?
    lastFrame = max([trials.trials.frames]);
    firstFrame = min(cellfun(@min, trials.frame_to_use));

    % find frames for each plane
    framePlanes = trials.frame_to_use;

    % extract frames for each plane and save
    figure(1);
    for i = 1:nPlanes
       planeDir = fullfile(sessionName, ['plane_' num2str(i)]);
       mkdir(planeDir);
       planeFile = fullfile(planeDir, [sessionID, '_plane_', num2str(i), '.h5']);

       % check frame dims
       q = sbxread(sessionName, 1, 1);
       q = squeeze(q);
       q = q(:,100:end-10);
       meanImg = q;

       h5create(planeFile, '/data', [size(q, 1), size(q, 2) Inf], 'DataType', 'uint16', 'ChunkSize',[size(q,1) size(q,2) 1])

       nFrames = length(framePlanes{1, i});
       refImg = zeros(size(q, 1), size(q, 2));
       
       c = 1;

       textprogressbar('converting frames: ')
       for f = framePlanes{1, i}
          q = sbxread(sessionName, f, 1);
          q = squeeze(q);
          q = q(:,100:end-10);
          textprogressbar((c/nFrames)*100);

          figure(1);
          subplot(1,2,1); imshow(q);
          meanImg = (meanImg+q)./2;
          subplot(1,2,2); imshow(meanImg);      

          h5write(planeFile,'/data',q,[1 1 c],[size(q,1) size(q,2) 1]);
          refImg = refImg+double(q);

          c = c+1;
       end
       textprogressbar('done');
       
       refImg = refImg./nFrames;
       imwrite(uint16(refImg), fullfile(planeDir, [sessionID, '_plane_', num2str(i), '_refImg.tiff']))
    end
    
    save(fullfile(sessionName, 'framePlanes.mat'), 'framePlanes');
end

