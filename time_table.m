%% This script allows to define the schedule matrix of the arriving and departing aircraft. Note that the function 'schedule.m' is needed to run the script

%% Assumption 1: three aircraft types are considered, namely B777, B737 and E190. It is assumed that these types arrive in sequence (i.e. B777 then B737 then E190 and then the sequence starts again).

%% Assumption 2: the number of passengers of the arriving and departing aircraft is the same and it is fixed per aircraft type.

%% Assumption 3: a turn around time of 90 minutes, 45 minutes and 35 minutes is considered for the B777, B737 and E190 respectively. These values can be changed by changing the variable 'wait' which can be found between lines 106 and 117

%% The time interval between two arriving aircraft is defined by the variable 'int' and it is initially set to 15 minutes, but it can be changed as you like. The script has been tested with values of 10,11,12,13,15,17,20,25,26,30 minutes

%% The schedule matrix is defined by the variable 'table': each row corresponds to one aircraft 

%%__________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

clc
clear all

int = 10; % each aircraft arrives every tot minutes as specified by int

B777 = 368; % max number of passesngers per aircraft type 
B737 = 116;
E190 = 96;
air_types = [B777,B737,E190];



day = 1440; % number of minutes in one day
stop = 120; % how much time before midnight flights stop arriving (in minutes). This is needed to avoid that aircraft depart after midnight
N = floor(day/int)-floor(stop/int) ; % number of aircraft in one day.   
table= zeros(N,day); % schedule matrix

air_list = ones(1,N); % list of arriving aircraft types 

i = 1; % counter aircraft  
t = 1; % counter passing minutes in a day
count = 1; % counter aircraft type


while t <= day-120
    
 
           
         
            
        if t/int-floor(t/int) == 0 % defines arrival time every tot minutes as specified by int. the if conditions implies an exact division 
                
            if nnz(table(i,1:day))< 2 % nnz --> number of non zero elements
            
                air_list(i) = count ;
            %%_____ defining arrival times for aircraft i in the form 'hhmm' (see function 'schedule.m' for further explanation') 
              
              
                timearr_hours = t/60; % arrival time in hours
                
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
                
                
                
               
                %_______ defining number of passengers and turn around times per flight based on aircarft type
                
              
                aircraft = air_types(count);
                %disp(aircraft)
               
                
                paxarr = aircraft; % so far it is assumed that aircraft arrive and depart with the same number of passengers
                paxdep = aircraft;
                
                if aircraft == air_types(1) %B777
                    
                    wait = 90 ; % time each aircraft spend parked 
                end
                
                if aircraft == air_types(2) %B737
                    wait = 45;
                end
                
                if aircraft == air_types(3) %E190
                    wait = 35;
                end
                
               
                
                %% defining time of departure for aircraft i in the form 'hhmm'
                
                timedep = t+wait; % departure time (in minutes from the beginning of the day)
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
            
            
                
                table(i,1:day) = schedule(timearr,timedep,paxarr,paxdep);
                
                disp('________________________')
                disp('aircraft number is: ')
                disp(i)
                disp('the arrival time is: ')
                disp(timearr)
                disp('the turn around time is: ')
                disp(wait)
                disp('the departure time is: ')
                disp(timedep)
                disp('________________________')
            
                i = i+1;
                count = count +1;
                
                
                if count == 4 % index count runs through the air_types list making sure that arriving aircraft alternate in type
                    count = 1;
                
                
                end
                
              
                
            end  % end if nnz
        end  % end if
  
    
    t = t+1;


end