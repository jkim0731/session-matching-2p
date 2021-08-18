%%
%% Manual info correction
%%
fn = '036_9998_208';
load([fn, '.mat'], 'info')

if length(find(info.event_id==3)) ~= length(info.messages)
    if length(find(info.event_id==2)) ~= length(info.messages)
        disp('Both start and end mismatch')
    else
        disp('Start mismatch')
    end
else
    if length(find(info.event_id==2)) ~= length(info.messages)
        disp('End mismatch')
    else
        disp('All Good')
    end
end
%%
tempMessages = cell(10,1);
tempMessages(2:end) = info.messages(1:9);
% % tempMessages(1:end) = info.messages(1:10);
tempMessages{1} = '154';
% tempMessages = info.messages(1:end-1);
% tempMessages{end} = [];

info.messages = tempMessages;

%%
info.event_id(1)=[];

%%
info.frame = [0; info.frame(1:end-1)];
info.line = [1; info.line(1:end-1)];
info.event_id = [2; info.event_id(1:end-1)];

%%
info.frame(end) = [];
info.line(end) = [];
info.event_id(end) = [];

%%
save([fn,'.mat'], 'info')
