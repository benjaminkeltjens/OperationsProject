function aircraft_schedules = scheduleToDictionary(schedule_matrix, aircraft_list, dt)

    N_aircraft = length(aircraft_list);
    
    aircraft_schedules.arrival_step = zeros(N_aircraft,1);
    aircraft_schedules.departure_step = zeros(N_aircraft,1);
    aircraft_schedules.stay_period = zeros(N_aircraft,1);
    aircraft_schedules.tow0stage1 = zeros(N_aircraft,2);
    aircraft_schedules.tow1stage1 = zeros(N_aircraft,2);
    aircraft_schedules.tow1stage2 = zeros(N_aircraft,2);
    aircraft_schedules.tow2stage1 = zeros(N_aircraft,2);
    aircraft_schedules.tow2stage2 = zeros(N_aircraft,2);
    aircraft_schedules.tow2stage3 = zeros(N_aircraft,2);
    
    arrival_turnaround = [60, 20, 10];
    
    for i = 1:N_aircraft
        aircraft = aircraft_list(i);
        
        schedule_indices = find(schedule_matrix(i,:));
        assert(length(schedule_indices) == 2);
        aircraft_schedules.arrival_step(i,:) = schedule_indices(1);
        aircraft_schedules.departure_step(i,:) = schedule_indices(2);
        length_stay =  schedule_indices(2)-schedule_indices(1)+1;
        aircraft_schedules.stay_period(i,:) = length_stay;
        
        arrival_t = arrival_turnaround(aircraft)/dt;
        
        %0 Tows
        aircraft_schedules.tow0stage1(i,:) = [schedule_indices(1), schedule_indices(2)];
        
        %1 Tow
        assert(schedule_indices(1)+arrival_t+1 <  schedule_indices(2));% Make sure that departure is at least 2 steps long
        aircraft_schedules.tow1stage1(i,:) = [schedule_indices(1), schedule_indices(1)+arrival_t];
        aircraft_schedules.tow1stage2(i,:) = [schedule_indices(1)+arrival_t+1, schedule_indices(2)];
        
        %2 Tow
        assert(schedule_indices(1)+arrival_t+1 < schedule_indices(2)-(10/dt)); % Make sure that the remote period is not less or equal to zero
        assert(schedule_indices(2)-(10/dt)+1 < schedule_indices(2)); % Make sure that departure is at least 2 steps long
        aircraft_schedules.tow2stage1(i,:) = [schedule_indices(1), schedule_indices(1)+arrival_t];
        aircraft_schedules.tow2stage2(i,:) = [schedule_indices(1)+arrival_t+1, schedule_indices(2)-(10/dt)];
        aircraft_schedules.tow2stage3(i,:) = [schedule_indices(2)-(10/dt)+1, schedule_indices(2)];
              
    end
end