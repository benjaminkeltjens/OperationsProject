function solution = generateSolutionStruct(x, N_aircraft, N_stages, N_gates, aircraft_schedules)
    solution.N_aircraft = N_aircraft;
    solution.N_gates = N_gates;
    solution.tow0stage1 = aircraft_schedules.tow0stage1;
    solution.tow1stage1 = aircraft_schedules.tow1stage1;
    solution.tow1stage2 = aircraft_schedules.tow1stage2;
    solution.tow2stage1 = aircraft_schedules.tow2stage1;
    solution.tow2stage2 = aircraft_schedules.tow2stage2;
    solution.tow2stage3 = aircraft_schedules.tow2stage3;
    
    solution.tow = zeros(N_aircraft,1);
    solution.gates = zeros(N_aircraft,3);
    
    for i = 1:N_aircraft
        % Get number of tows
        tow_i = find(x(towIndex(i,1,N_aircraft,N_stages,N_gates):towIndex(i,3,N_aircraft,N_stages,N_gates)));
        assert(length(tow_i)==1);
        solution.tow(i) = tow_i-1;
        
        if tow_i == 1
            gate_0_1 = find(x(varIndex(i,1,1,N_stages,N_gates):varIndex(i,1,N_gates,N_stages,N_gates)));
            solution.gates(i,:) = [gate_0_1,0,0];
        end
        
        if tow_i == 2
            gate_1_1 = find(x(varIndex(i,2,1,N_stages,N_gates):varIndex(i,2,N_gates,N_stages,N_gates)));
            gate_1_2 = find(x(varIndex(i,3,1,N_stages,N_gates):varIndex(i,3,N_gates,N_stages,N_gates)));
            solution.gates(i,:) = [gate_1_1, gate_1_2, 0];
        end
        
        if tow_i == 3
            gate_2_1 = find(x(varIndex(i,4,1,N_stages,N_gates):varIndex(i,4,N_gates,N_stages,N_gates)));
            gate_2_2 = find(x(varIndex(i,5,1,N_stages,N_gates):varIndex(i,5,N_gates,N_stages,N_gates)));
            gate_2_3 = find(x(varIndex(i,6,1,N_stages,N_gates):varIndex(i,6,N_gates,N_stages,N_gates)));
            solution.gates(i,:) = [gate_2_1, gate_2_2, gate_2_3];
        end
    end