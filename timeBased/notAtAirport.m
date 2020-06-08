function time_array = notAtAirport(i, aircraft_schedules, schedule_matrix)

    final_index = size(schedule_matrix);
    final_index = final_index(2);
    arrival_index = aircraft_schedules.arrival_step(i);
    departure_index = aircraft_schedules.departure_step(i);
    time_array = [1:arrival_index-1, departure_index+1:final_index];
end