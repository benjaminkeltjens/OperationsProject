%% This script allows to define the schedule matrix of the arriving and departing aircraft. Note that the function 'schedule.m' is needed to run the script

%% Assumption 1: three aircraft types are considered, namely B777, B737 and E190. It is assumed that these types arrive in sequence (i.e. B777 then B737 then E190 and then the sequence starts again).

%% Assumption 2: the number of passengers of the arriving and departing aircraft is the same and it is fixed per aircraft type.

%% Assumption 3: a turn around time of 90 minutes, 45 minutes and 35 minutes is considered for the B777, B737 and E190 respectively. These values can be changed by changing the variable 'wait' which can be found between lines 106 and 117

%% The time interval between two arriving aircraft is defined by the variable 'int' and it is initially set to 15 minutes, but it can be changed as you like. The script has been tested with values of 10,11,12,13,15,17,20,25,26,30 minutes

%% The schedule matrix is defined by the variable 'table': each row corresponds to one aircraft 

%%__________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

% clc
% clear all
rng(1);

int = 10; % each aircraft arrives every tot minutes as specified by int

B777 = 368; % max number of passesngers per aircraft type 
B737 = 116;
E190 = 96;
air_types = [B777,B737,E190];



day = 1440; % number of minutes in one day
stop = 120; % how much time before midnight flights stop arriving (in minutes). This is needed to avoid that aircraft depart after midnight
N = floor(day/int)-floor(stop/int) ; % number of aircraft in one day.   
schedule_table= zeros(N,day); % schedule matrix

air_list = ones(1,N); % list of arriving aircraft types 

i = 1; % counter aircraft  
t = 1; % counter passing minutes in a day
count = 1; % counter aircraft type

% Defining delays 

delrunarr = 1; % counter defining delayed aircraft (arrival) 
deltotarr = 12; % after tot flights one aircraft is delayed (arrival) : so one aircraft in 'deltotarr' will arrive with a delay of 'delayarr' minutes
delrundep = 1; % counter defining delayed aircraft (departure)
deltotdep = 5; % after tot flights one aircraft is delayed (departure) : so one aircraft in 'deltotdep' will be delayed by 'delaydep' amount

delayarr = 20; % aircraft delay in arrival (in minutes)
delaydep = 35; % aircraft delay in departure (in minutes) 


paxfactor = [0.6 0.75 0.90 1];% list defining the factors to multiply the number of passengers with in order to obtain a number of arriving and departing passengers not necessarily equal to the max amount of pax for a specific aircraft type

% unexpected1 = randi(N);        
% unexpected2 = randi(N);
%       
% while unexpected2 == unexpected1 % with this while loop you want to make sure that the two unexpected events do not occurr to the same aircraft 
%     
% unexpected2 = randi(length(N));
%     
% end


while t <= day-120
    
 
           
         
            
        if t/int-floor(t/int) == 0 % defines arrival time every tot minutes as specified by int. the if conditions implies an exact division 
                
            if nnz(schedule_table(i,1:day))< 2 % nnz --> number of non zero elements, so i corresponds to the aircraft 
            
               
            %%_____ defining arrival times for aircraft i in the form 'hhmm' (see function 'schedule.m' for further explanation') 
              
              
                timearr_hours = t/60; % arrival time in hours
                
                if delrunarr == deltotarr
                    timarr_hours = (t+delayarr)/60;
                end
                    
                
                if timearr_hours < 10
                    
                    minutes_arr = (timearr_hours-floor(timearr_hours))*60;
                    
                    if minutes_arr < 9.1 % .1 is needed to avoid problems when minute of arrival is exactly 9
                        
                        if minutes_arr == 0
                    
                            timearr =  string(string(0)+floor(timearr_hours))+string((timearr_hours-floor(timearr_hours))*60+string(0)); % arrival time expressed in the form 'hhmm'
                        else
                            timearr =  string(string(0)+floor(timearr_hours))+string(0)+string((timearr_hours-floor(timearr_hours))*60); % arrival time expressed in the form 'hhmm'
                        end
                    else
                    
                    timearr =  string(string(0)+floor(timearr_hours))+string((timearr_hours-floor(timearr_hours))*60); % arrival time expressed in the form 'hhmm'
                    
                    end
                    
                else
                        minutes_arr = (timearr_hours-floor(timearr_hours))*60;
                        if minutes_arr < 9.1 % .1 is needed to avoid problems when minute of arrival is exactly 9
                    
                            if minutes_arr == 0
                    
                                timearr =  string(floor(timearr_hours))+string((timearr_hours-floor(timearr_hours))*60+string(0)); % arrival time expressed in the form 'hhmm'
                            else
                                timearr =  string(floor(timearr_hours))+string(0)+string((timearr_hours-floor(timearr_hours))*60); % arrival time expressed in the form 'hhmm'
                            end
                    
                        else
                    
                            timearr =  string(floor(timearr_hours))+string((timearr_hours-floor(timearr_hours))*60); % arrival time expressed in the form 'hhmm'
                   
                        end
                end
                
                
                
                timearr = char(timearr);
                
                
                
               
                %_______ defining aircraft type, number of passengers and turn around times per flight based on aircarft type
                
                itemaircraft = randi(length(air_types));
                aircraft = air_types(itemaircraft);
                air_list(i) = itemaircraft;
                %disp(aircraft)
               
               
                %__number of passengers
                
                itemarr = randi(length(paxfactor));
                paxpickarr = paxfactor(itemarr);
                
                paxarr = floor(aircraft*paxpickarr); % so far it is assumed that aircraft arrive and depart with the same number of passengers
                
                itemdep = randi(length(paxfactor));
                paxpickdep = paxfactor(itemdep);
                paxdep = floor(aircraft*paxpickdep);
                
                %______turnaround times and delay times 
                
                if aircraft == air_types(1) %B777
                    
                    wait = 90 ; % time each aircraft spend parked 
                end
                
                if aircraft == air_types(2) %B737
                    wait = 45;
                end
                
                if aircraft == air_types(3) %E190
                    wait = 35;
                end
                
%_____________________________________defining unexpected events for which
%an aircraft stays grounded for 5 hours___________________________________
% these unexpected events are indipendent from the other delays


while count <= 1
    
    if i/deltotdep - floor(i/deltotdep) ~=0
    if i/deltotarr - floor(i/deltotarr) ~=0
        
        unexpected1 = randi(N);
%         disp('UNEXP 1 :')
%         disp(unexpected1)
        
        unexpected2 = randi(N);
%         disp('UNEXP 2 :')
%         disp(unexpected2)
      
        while unexpected2 == unexpected1 % with this while loop you want to make sure that the two unexpected events do not occurr to the same aircraft 
    
              unexpected2 = randi(length(N));
    
        end
        


    end
    end
    
    count = count + 1;
end

    
if i == unexpected1;
    
    wait = 300;
    %disp(i)
    %disp(wait)
    
    if t>= day-wait
        
        wait = day-t;
        
    end
    
end


    
if i == unexpected2;
    
    wait = 300;
    if t>= day-wait
        
        wait = day-t;
        
    end
    
end
               
               
                
                %% defining time of departure for aircraft i in the form 'hhmm'
                
                
                
                
                timedep = t+wait; % departure time (in minutes from the beginning of the day)
                
                if delrundep == deltotdep
                    timedep = t+wait+delaydep;
                end
                
                timedep_hours = timedep/60;
              
                
                
                if timedep_hours < 10
                    
                    minutes_dep = (timedep_hours-floor(timedep_hours))*60;
                    
                    
                    if minutes_dep <9.1 % .1 is needed to avoid problems when minute of departure is exactly 9
                        
                        
                        if minutes_dep == 0
                            timedep =  string(string(0)+floor(timedep_hours))+string((timedep_hours-floor(timedep_hours))*60+string(0));
                        else
                            timedep =  string(string(0)+floor(timedep_hours))+string(0)+string((timedep_hours-floor(timedep_hours))*60);
                        end
                        
                        
                    else
                        timedep =  string(string(0)+floor(timedep_hours))+string((timedep_hours-floor(timedep_hours))*60);
                    
                    end
                    
                        
                else
                    minutes_dep = (timedep_hours-floor(timedep_hours))*60;
                    
                    
                    
                    if minutes_dep < 9.1 % .1 is needed to avoid problems when minute of departure is exactly 9 
                        
                        if minutes_dep == 0
                            
                            timedep =  string(floor(timedep_hours))+string((timedep_hours-floor(timedep_hours))*60+string(0));
                        else
                            timedep =  string(floor(timedep_hours))+string(0)+string((timedep_hours-floor(timedep_hours))*60);
                        end   
                    else
                        timedep = string(floor(timedep_hours))+string((timedep_hours-floor(timedep_hours))*60);
                    
                    end
                    
                   
                    
                end
                
               
                timedep = char(timedep);
            
            
                
                schedule_table(i,1:day) = schedule(timearr,timedep,paxarr,paxdep);
                
                disp('__________________________________________________________')
                disp('flight number is: ')
                disp(i)
                disp('...')
                
                if  count== 1
                    disp('aircraft type is: ')
                    disp('B777')
                end
                
                if  count == 2
                    disp('aircraft type is: ')
                    disp('B737')
                end
                
                if  count== 3
                    disp('aircraft type is: ')
                    disp('E190')
                end
                
                disp('...')
                
                if delrunarr == deltotarr
                    disp('the flight arrival time has been delayed by minutes: ')
                    disp(delayarr)
                end
                disp('the arrival time is: ')
                disp(timearr)
                %disp('factor arr is: ')
                %disp(paxpickarr)
                disp('the number of arriving passengers is: ')
                disp(paxarr)
                disp('....')
                disp('the turn around time is: ')
                disp(wait)
                
                if delrundep == deltotdep
                   disp('aircraft departure is delayed by minutes: ')
                   disp(delaydep)
                end
                disp('...') 
                disp('the departure time is: ')
                disp(timedep)
                %disp('factor dep is: ')
                %disp(paxpickdep)
                disp('and the number of departing passengers is: ')
                disp(paxdep)
             
                disp('__________________________________________________________')
            
                i = i+1;
                %count = count +1;
                delrundep = delrundep +1; 
                delrunarr = delrunarr +1;
                
                
                %if count == 4 % index count runs through the air_types list making sure that arriving aircraft alternate in type
                    %count = 1;
                %end
                
                if delrundep == deltotdep+1
                    delrundep = 1;
                end
                
                if delrunarr == deltotarr+1
                    delrunarr = 1;
                end
                
              
                
            end  % end if nnz
        end  % end if
  
    
    t = t+1;


end