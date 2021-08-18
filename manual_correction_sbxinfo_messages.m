%%
%% Manual info correction
%%
fn = '025_9999_1082';
load([fn, '.mat'], 'info')
%%
tempMessages = cell(10,1);
tempMessages(1:end) = info.messages(1:10);
% tempMessages{1} = '124';
info.messages = tempMessages;


%%
info.frame = [0; info.frame(1:end-1)];
info.line = [1; info.line(1:end-1)];
info.event_id = [2; info.event_id(1:end-1)];

%%
info.frame(end) = [];
info.line(end) = [];
info.event_id(end) = [];
%%

%%
save([fn,'.mat'], 'info')
