function [gate_matrix, tow_cost, aircraft_list, schedule_matrix] = getProblemVars(dt)
    vectors;
    gate_matrix = gates_matrix;
    tow_cost = towcostvec';
    
    time_table;
    aircraft_list = air_list';
%     schedule_matrix = schedule_table;
%     schedule_table(1,1:20) = linspace(1,20,20);
    %% Refine Schedule
%     schedule_table = table;
    schedule_matrix = schedule_table(:,dt:dt:end);
end