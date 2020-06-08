addpath("/home/benjamin/CPLEX_Studio1210/cplex/matlab/x86-64_linux");
clearvars
clc
clear

%% Problem Set-up
% global dt;
% global N_aircraft;
% global N_gates;
% global N_steps;
% global N_stages;
dt = 5; %Minutes
[gate_matrix, tow_cost, aircraft_list, schedule_matrix] = getProblemVars(5);
N_aircraft = length(aircraft_list);
N_gates = length(gate_matrix);
N_steps = length(schedule_matrix);
N_stages = 6;

aircraft_schedules = scheduleToDictionary(schedule_matrix, aircraft_list, dt);


%% CPlex Set-up
model = 'Bay-Assignment';
cplex = Cplex(model);
cplex.Model.sense = 'minimize';

DV = N_aircraft*N_stages*N_gates*N_steps + N_aircraft*3; % Bay Decision Variables + Tow Decision Variables
obj = zeros(DV,1);

tic
%% Objective Function
disp('Generating Objective Function')
disp('____________________________')
% Travel Distance
for i = 1:N_aircraft
    i
    for s = 1:N_stages
        for j = 1:N_gates
            for t = 1:N_steps
                obj(varIndex(i,s,j,t),1) = schedule_matrix(i,t) * gate_matrix(j,1);
%                 NameDV(varIndex(i,s,j,t),:) = ['X_' num2str(i,'%02d') '_' num2str(s,'%02d') '_' num2str(j,'%02d') '_' num2str(t,'%02d')];
            end
        end
    end
    for n = 1:3
        obj(towIndex(i,n),1) = tow_cost(n);
%         NameDV(towIndex(i,n),:) = ['Z_' num2str(i,'%02d') '_' num2str(n,'%02d')];
    end
end
% load('obj.mat')
% obj = obj';
ctype1 = char(ones(1, (DV)) * ('B'));  %B=binary.
ctype = strcat(ctype1);
lb = zeros(DV,1);
ub = ones(DV,1);
% cplex.addCols(obj, [], ctype,NameDV);
cplex.addCols(obj, [], lb, ub, ctype);
objective_time = toc

%% Constraint 1: One aircraft per gate
disp('Generating Constraint 1')
disp('____________________________')
tic
for j = 1:N_gates-1
    j
    for t = 1:N_steps
        t
        C1 = zeros(1,DV);
        for i = 1:N_aircraft
            i;
            for s = 1:N_stages
                s;
                C1(varIndex(i,s,j,t)) = 1;
            end
        end
        cplex.addRows(-inf, C1, 1, sprintf('Constraint1%d_%d', j,t));
    end
end
constrain1_time = toc

%% Constraint 2: One Type of Tow
disp('Generating Constraint 2')
disp('____________________________')
tic
for i = 1:N_aircraft
    i
    C2 = zeros(1,DV);
    for n = 1:3
        C2(towIndex(i,n)) = 1;
    end
    cplex.addRows(0,C2,1,sprintf('Constrain2%d',i));
end
constraint2_time = toc

%% Constraint 3: Constraint Amount of Tows
disp('Generating Constraint 3')
disp('____________________________')
tic
for i = 1:N_aircraft
    i
    for n = 1:3
        C3 = zeros(1,DV);
        for j = 1:N_gates
            for t = atAirport(i, aircraft_schedules)
                if n ==1
                    C3(varIndex(i,1,j,t)) = 1;
                end
                if n==2
                    C3(varIndex(i,2,j,t)) = 1;
                    C3(varIndex(i,3,j,t)) = 1;
                end
                if n==3
                    C3(varIndex(i,4,j,t)) = 1;
                    C3(varIndex(i,5,j,t)) = 1;
                    C3(varIndex(i,6,j,t)) = 1;
                end
            end
        end
        C3(towIndex(i,n)) = -1000000;
        cplex.addRows(-inf,C3,0,sprintf('Constrain3%d_%d',i,n));      
    end
end
constraint3_time = toc
        
%% Constraint 4: Must be assigned to a gate while at airport
disp('Generating Constraint 4')
disp('____________________________')
tic
for i = 1:N_aircraft
    i
    C4 = zeros(1,DV);
    for s = 1:N_stages
        for j = 1:N_gates
            for t = 1:N_steps
                C4(varIndex(i,s,j,t)) = 1;
            end
        end
    end
    cplex.addRows(0,C4,aircraft_schedules.stay_period(i),sprintf('Constrain4%d',i));
end
constraint4_time = toc

%% Constraint 5: Gate for each stage stays the same
disp('Generating Constraint 5')
disp('____________________________')
constraint5_time = tic
for i = 1:N_aircraft
    i
    for s = 1:N_stages
        for j = 1:N_gates
            for t = sameGateConstraint(i,s,aircraft_schedules)
                C5 = zeros(1,DV);
                C5(varIndex(i,s,j,t)) = 1;
                C5(varIndex(i,s,j,t-1)) = -1;
                cplex.addRows(0,C5,0,sprintf('Constrain5%d_%d_%d_%d',i,s,j,t));
            end
        end
    end
end
constraint5_time = toc

%% Constrain 6: All time not at airport
disp('Generating Constraint 6')
disp('____________________________')
tic
C6 = zeros(1,DV);
for i = 1:N_aircraft
    i
    for s = 1:N_stages
        for j = 1:N_stages
            for t = notAtAirport(i, aircraft_schedules, schedule_matrix)
                C6(varIndex(i,s,j,t)) = 1;
            end
        end
    end
end
cplex.addRows(0,C6,0,sprintf('Constraint6'));
constraint6_time = toc

%% Constraint 7: All Gates not possible
disp('Generating Constraint 7')
disp('____________________________')
tic
C7 = zeros(1,DV);
for i = 1:N_aircraft
    i
    for s = 1:N_stages
        for j = gateNotPossible(i, gate_matrix, aircraft_list)
            for t = 1:N_steps
                C7(varIndex(i,s,j,t)) = 1;
            end
        end
    end
end
cplex.addRows(0,C7,0,sprintf('Constraint7'));
constraint7_time = toc

%% Run Model
tic
cplex.writeModel([model '.lp'])
% cplex.Param.timelimit.Cur = 100;
cplex.solve();
solve_time = toc
 
                    
    

