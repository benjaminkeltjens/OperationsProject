function cost = costCoefficient(i,s,schedule_matrix,aircraft_schedules)
    if s == 1
        cost = schedule_matrix(i,aircraft_schedules.arrival_step(i)) + schedule_matrix(i,aircraft_schedules.departure_step(i));
   
    elseif s == 2
        cost = schedule_matrix(i,aircraft_schedules.arrival_step(i));
        
    elseif s == 3
        cost = schedule_matrix(i,aircraft_schedules.departure_step(i));
        
    elseif s == 4
        cost = schedule_matrix(i,aircraft_schedules.arrival_step(i));
        
    elseif s == 5
        cost = 0;
    
    elseif s == 6
        cost = schedule_matrix(i,aircraft_schedules.departure_step(i));
    end
end