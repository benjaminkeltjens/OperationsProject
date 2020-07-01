function [total_time, tows_0, tows_1, tows_2] = produceStats(solution, gate_matrix, schedule_matrix, aircraft_schedules)
total_time = 0;
tows_0 = 0;
tows_1 = 0;
tows_2 = 0;
for i = 1:solution.N_aircraft
    if solution.tow(i) == 0
        tows_0 = tows_0 + 1;
        time_1 = gate_matrix(solution.gates(i,1),1)*(schedule_matrix(i,aircraft_schedules.arrival_step(i)) + schedule_matrix(i,aircraft_schedules.departure_step(i)));
        total_time = total_time + time_1;
    elseif solution.tow(i) == 1
        tows_1 = tows_1 + 1;
        time_2 =  gate_matrix(solution.gates(i,1),1)*(schedule_matrix(i,aircraft_schedules.arrival_step(i)));
        time_3 =  gate_matrix(solution.gates(i,2),1)*(schedule_matrix(i,aircraft_schedules.departure_step(i)));
        total_time = total_time + time_2 + time_3;
    elseif solution.tow(i) == 2
        tows_2 = tows_2 + 1;
        time_4 =  gate_matrix(solution.gates(i,1),1)*(schedule_matrix(i,aircraft_schedules.arrival_step(i)));
        time_6 =  gate_matrix(solution.gates(i,3),1)*(schedule_matrix(i,aircraft_schedules.departure_step(i)));
        total_time = total_time + time_4 + time_6;
    end
end
disp(sprintf('Total Time: %08d',total_time));
disp(sprintf('Amount of 0 Tows: %d', tows_0));
disp(sprintf('Amount of 1 Tows: %d', tows_1));
disp(sprintf('Amount of 2 Tows: %d', tows_2));

end

