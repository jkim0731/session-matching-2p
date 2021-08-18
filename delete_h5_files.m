targetDir = 'J:\';

% Removing error sessions
mice = [30,36];
sessions = {[16],[12]};
planes = 1:8;

for mi = 1 : length(mice)
    mouse = mice(mi);
    for pi = 1 : length(planes)
        plane = planes(pi);
        cd(sprintf('%s%03d\\plane_%d',targetDir, mouse, plane))
        for si = 1 : length(sessions{mi})
            session = sessions{mi}(si);
            fnList = dir(sprintf('%03d_%03d_*_plane_%d.h5', mouse, session, pi));
            for fi = 1 : length(fnList)
%                 if fnList(fi).bytes < 1e+9
                    delete(fnList(fi).name)
%                 end
            end
        end
    end
end

%% Changing new files into old format
% after changing x and y dimension
% 
% 2021/02/03 JK (to empty some of the spaces)

baseDir = 'D:\TPM\JK\h5\';
% mice = [25,27,30,36,37,38,39]; % 41-56 needs to be converted.
% mice = 41;
mice = [52,53,54,56];
for mi = 1 : length(mice)
    mouse = mice(mi);
    for pi = 1 : 8
        targetDir = sprintf('%s%03d\\plane_%d\\',baseDir,mouse,pi);
        newflist = dir([targetDir, 'new_*.h5']);
        for fi = 1 : length(newflist)
            newfn = newflist(fi).name;
            oldfn = newfn(5:end);

            FileRename([targetDir, newfn], [targetDir, oldfn], 'forced')

        end
    end
end

%% Removing subfolder files

baseDir = 'D:\TPM\JK\h5\';
mice = [25,27,30,36,37,38,39,41,52,53,54,56];
for mi = 1 : length(mice)
    mouse = mice(mi);
    for pi = 1 : 8
        currDir = sprintf('%s%03d\\plane_%d\\', baseDir, mouse, pi);
        dlist = dir(sprintf('%s%03d_*_plane_%d', currDir, mouse, pi));
        for di = 1 : length(dlist)
            if dlist(di).isdir
                flist = dir([currDir, dlist(di).name, filesep, '*.h5']);
                for fi = 1 : length(flist)
                    delete([flist(fi).folder, filesep, flist(fi).name]);
                end
            end
        end
    end
end