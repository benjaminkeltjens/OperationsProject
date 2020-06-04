function [day] = schedule(timearr,timedep,paxarr,paxdep)
%% This function defines the arriving and departing time of an aircraft: as an input it takes the desired arrival and departure times as strings in the form 'hhmm' and the number of arriving and departing passengers
%  The output of the function is a 1 by 1440 vector conatining zero elements but the number of arriving and departing passengers located at index minute of arrival and departure from the beginning of the day (idxarr and idxdep respectively) 


% timearr and timedep are strings to be defined as : 'hhmm', e.g. '1135'
% corresponds to time 11:35 

day = zeros(1,1440); % minutes in a day

arrh = str2num(timearr(1:2))*60;%hour of arrival 
arrmin = str2num(timearr(3:4));% minute of arrival

idxarr = arrh + arrmin;

day(idxarr) = paxarr;

deph = str2num(timedep(1:2))*60;%hour of departure 
depmin = str2num(timedep(3:4));% minute of departure

idxdep = deph + depmin; 
day(idxdep) = paxdep;


end

