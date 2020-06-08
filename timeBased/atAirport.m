function time_array = atAirport(i, aircraft_schedules)
    time_array = aircraft_schedules.arrival_step(i):aircraft_schedules.departure_step(i);
end