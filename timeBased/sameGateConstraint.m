function time_array = sameGateConstraint(i,s,aircraft_schedules)
    
    if s == 1
        time_array = aircraft_schedules.tow0stage1(i,1)+1:aircraft_schedules.tow0stage1(i,2);
    end
    
    if s == 2
        time_array = aircraft_schedules.tow1stage1(i,1)+1:aircraft_schedules.tow1stage1(i,2);
    end
    
    if s == 3
        time_array = aircraft_schedules.tow1stage2(i,1)+1:aircraft_schedules.tow1stage2(i,2);
    end
    
    if s == 4
        time_array = aircraft_schedules.tow2stage1(i,1)+1:aircraft_schedules.tow2stage1(i,2);
    end
    
    if s == 5
        time_array = aircraft_schedules.tow2stage2(i,1)+1:aircraft_schedules.tow2stage2(i,2);
    end
    
    if s == 6
        time_array = aircraft_schedules.tow2stage3(i,1)+1:aircraft_schedules.tow2stage3(i,2);
    end
    
end