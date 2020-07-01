function schedule_matrix = coarseScheduleToMatrix(coarse, dt)
    N_aircraft = size(coarse,1);
    schedule_matrix = zeros(N_aircraft,1440/dt);
    for i = 1:N_aircraft
        time_a = coarse(i,1)/dt;
        time_d = coarse(i,2)/dt;
        pax_a = coarse(i,3);
        pax_d = coarse(i,4);
        
        schedule_matrix(i,time_a) = pax_a;
        schedule_matrix(i,time_d) = pax_d;
    end
end