function [ganttmatarr,ganttmatdep,slotmatrix,off] = gantt(solution)

% This function returns the Gantt chart with the assignment of the aircraft
% at each gate. It takes as an input the struct containing the nr of tows
% per aircraft, the gates and the arriving and departingn times.

tows = solution.tow;
gatesall = solution.gates;
count = 1; 

N = 0; % defining the total amount of aircaft movements 

for i = 1:length(gatesall)
    for x = 1:3
        
        if gatesall(i,x) ~= 0
            
            N = N+1;
        
        end
    
    end
end

timearr = zeros(1,N);
timedep = zeros(1,N);
gates =  zeros(1,N);
flights = zeros(1,N);

for i = 1:length(tows)
    
    %disp('aircaft number is: ')
    %disp(i)
    %disp('tows number is: ')
    %disp(tows(i))
    
    if tows(i) == 0
      
        timearr(count) = solution.tow0stage1(i,1);
        timedep(count) = solution.tow0stage1(i,2);
        gates(count) = gatesall(i,1);
        flights(count) = i;        
        count = count+1;
    end
    
    
    if tows(i) == 1
        
        timearr(count) = solution.tow1stage1(i,1); % time of arrival at first gate
        timedep(count) = solution.tow1stage1(i,2); % time of departure from first gate 
        gates(count) = gatesall(i,1);
        %disp('.............')
        timearr(count+1) = solution.tow1stage2(i,1); % time of arrival at second gate 
        timedep(count+1) = solution.tow1stage2(i,2); % time of departure from second gate
        gates(count+1) = gatesall(i,2);
        count = count+2;   
    end
    
     if tows(i) == 2
        
        timearr(count) = solution.tow2stage1(i,1); % time of arrival at first gate
        timedep(count) = solution.tow2stage1(i,2); % time of departure from first gate 
        gates(count) = gatesall(i,1);
        
        timearr(count+1) = solution.tow2stage2(i,1); % time of arrival at second gate 
        timedep(count+1) = solution.tow2stage2(i,2); % time of departure from second gate
        gates(count+1) = gatesall(i,2);
        
        timearr(count+2) = solution.tow2stage3(i,1); % time of arrival at third gate 
        timedep(count+2) = solution.tow2stage3(i,2); % time of departure from third gate
        gates(count+2) = gatesall(i,3);
        count = count+3;
            
    end
    
%     for i = N:-1:1
%         
%         gate = string(gates(i));
%         barh(timedep(i),'b','Edgecolor','w');
%         hold on
%         barh(timearr,'w','Edgecolor','w')
%         %yticklabels({'gate :'+ gate});
%         
%     end
    
        
% 
%     barh(timedep,'b','Edgecolor','w');
%     hold on
%     barh(timearr,'w','Edgecolor','w');
%     
%     
%     for i = 1:length(gates)
%       gates(i) = string(gates(i));
%     end
%     yticklabels({gates});

% max(solution.gates, [], 'all'); %finds maximum value in a matrix
% sum(solution.gates(:)==3) % finds how many times the value 3 occurs
% in the matrix 

end

number_of_gates = solution.N_gates; %max(solution.gates, [], 'all'); % number of gates 
assignment_count = zeros(1,number_of_gates);

for i = 1:number_of_gates
    
    assignment_count(i) = sum(solution.gates(:)==i);
end

max_ac_day = max(assignment_count); % max number of aircraft assigned to one gate per day;

% defining materices having the following characteristics : each row
% corresponds to a gate and each column corresponds to the arrival
% (ganttmatarr) or departure (ganttmatdep) of the different aircarft
% assigned at that specific gate during the day.

ganttmatarr = zeros(number_of_gates,max_ac_day);
ganttmatdep = zeros(number_of_gates,max_ac_day);

for i = 1:number_of_gates
    
    index = find(gates == i );
    
    for j = 1 :length(index)
        
        ganttmatarr(i,j) = timearr(index(j));
        ganttmatdep(i,j) = timedep(index(j));
        
    end
    
end


% for i = 1:number_of_gates
%     
%     index = find(gates == i );
%     
%     for j = 1 :length(index)
%         
%         ganttmatdep(i,j) = timedep(index(j));
%         
%     end
%     
% end

% defining the matrix containing the on/off slots  
slotmatrix = zeros(number_of_gates,2*max_ac_day);

off = zeros(1,max_ac_day);% columns of the slot matrix which should not be visible in the gantt chart  
% disp('off is: ')
% disp(off)

for i = 1:number_of_gates
        
        arrival = ganttmatarr(i,:);
        departure = ganttmatdep(i,:);
        slotarray = stack(arrival,departure);
       
%         disp('slotarray is: ')
%         disp(slotarray)
%         
        %slotmatrix(i,1:end) = slotarray;
        
        for j = 1:length(slotarray)
            
            slotmatrix(i,j) = slotarray(j);
            
            if j/2 - floor(j/2) ~=0
                
                if j == 1
                    off(j) = 1;
                else        
                    off(j-1) = j;
                end
           
            end
            
        end
               
end

% drawing the Gantt chart 

gates = 1:number_of_gates;


off = (off ~= 0);
off
Gantt = barh(gates,slotmatrix,'stacked');

% save('off.mat',off);
set(Gantt(off),'Visible','off');





end

