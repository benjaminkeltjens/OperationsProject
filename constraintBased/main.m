addpath("/home/benjamin/CPLEX_Studio1210/cplex/matlab/x86-64_linux");
clearvars
clc
clear

%% Problem Set-up
dt = 5; %Minutes
[gate_matrix, tow_cost, aircraft_list, schedule_matrix] = getProblemVars(5);
N_aircraft = length(aircraft_list);
N_gates = length(gate_matrix);
N_stages = 6;
N_steps = 1440/dt;

aircraft_schedules = scheduleToDictionary(schedule_matrix, aircraft_list, dt);
stage_presence = concurrentStages(aircraft_schedules,N_aircraft,dt);


%% CPlex Set-up
model = 'Bay-Assignment';
cplex = Cplex(model);
cplex.Model.sense = 'minimize';

DV = N_aircraft*N_stages*N_gates + N_aircraft*3; % Bay Decision Variables + Tow Decision Variables
obj = zeros(DV,1);

tic
%% Objective Function
disp('Generating Objective Function')
disp('____________________________')
% Travel Distance
for i = 1:N_aircraft
    for s = 1:N_stages
        for j = 1:N_gates
                obj(varIndex(i,s,j,N_stages,N_gates),1) =  costCoefficient(i,s,schedule_matrix,aircraft_schedules) * gate_matrix(j,1);
                NameDV(varIndex(i,s,j,N_stages,N_gates),:) = ['X_' num2str(i,'%03d') '_' num2str(s,'%01d') '_' num2str(j,'%02d')];
        end
    end
    for n = 1:3
        obj(towIndex(i,n,N_aircraft,N_stages,N_gates),1) = tow_cost(n);
        NameDV(towIndex(i,n,N_aircraft,N_stages,N_gates),:) = ['Z___' num2str(i,'%03d') '__' num2str(n,'%01d')];
    end
end

ctype1 = char(ones(1, (DV)) * ('B'));  %B=binary.
ctype = strcat(ctype1);
lb = zeros(DV,1);
ub = ones(DV,1);
cplex.addCols(obj, [], lb, ub, ctype,NameDV);
% cplex.addCols(obj, [], lb, ub, ctype);
objective_time = toc

%% Constraint 1: One aircraft per gate
disp('Generating Constraint 1')
disp('____________________________')

tic
for t = 1:N_steps
    i_s_combinations = getISCombinations(stage_presence,t);
    if ~isempty(i_s_combinations)
        for j = 1:N_gates-1 % -1 because remote can hold unlimited planes (remote is last gate always)
            C1 = zeros(1,DV);
            for m = 1:length(i_s_combinations)
                i_s = i_s_combinations(m,:);
                C1(varIndex(i_s(1),i_s(2),j,N_stages,N_gates)) = 1;
            end
            cplex.addRows(-inf, C1, 1, sprintf('Constraint1%03d_%02d', t,j));
        end
    end
end
constraint1_time = toc

%% Constraint 2: One Type of Tow
disp('Generating Constraint 2')
disp('____________________________')
tic
for i = 1:N_aircraft
    C2 = zeros(1,DV);
    for n = 1:3
        C2(towIndex(i,n,N_aircraft,N_stages,N_gates)) = 1;
    end
    cplex.addRows(1,C2,1,sprintf('Constraint2%03d',i));
end
constraint2_time = toc

%% Constraint 3: Constraint Amount of Tows
disp('Generating Constraint 3')
disp('____________________________')
tic
for i = 1:N_aircraft
    for s = 1:N_stages
        C3 = zeros(1,DV);
        for j = 1:N_gates
            C3(varIndex(i,s,j,N_stages,N_gates)) = 1;
        end
        if s == 1
            C3(towIndex(i,1,N_aircraft,N_stages,N_gates)) = -1;
        end
        if s == 2 || s == 3
            C3(towIndex(i,2,N_aircraft,N_stages,N_gates)) = -1;
        end
        if s == 4 || s == 5 || s == 6
            C3(towIndex(i,3,N_aircraft,N_stages,N_gates)) = -1;
        end
        cplex.addRows(0,C3,0,sprintf('Constraint3%03d_%01d',i,s));  
    end
    
end
constraint3_time = toc
        
%% Constraint 4: All Gates not possible
disp('Generating Constraint 4')
disp('____________________________')
tic
C4 = zeros(1,DV);
for i = 1:N_aircraft
    for s = 1:N_stages
        for j = gateNotPossible(i, gate_matrix, aircraft_list)
            C4(varIndex(i,s,j,N_stages,N_gates)) = 1;
        end
    end
end
cplex.addRows(0,C4,0,sprintf('Constraint4'));
constraint4_time = toc

%% Constraint 5: Can't Board or Disembark at Remote
disp('Generating Constraint 5')
disp('____________________________')
tic
C5 = zeros(1,DV);
for i = 1:N_aircraft
    for s = [1,2,3,4,6] %Can only be at remote at s=5
        C5(varIndex(i,s,N_gates,N_stages,N_gates)) = 1;
    end
end
cplex.addRows(0,C5,0,sprintf('Constraint5'));
constraint5_time = toc

%% Run Model
tic
cplex.writeModel([model '.lp'])
% cplex.Param.timelimit.Cur = 100;
cplex.solve();
solve_time = toc

solution = generateSolutionStruct(cplex.Solution.x, N_aircraft, N_stages, N_gates, aircraft_schedules);


 
                    
    


