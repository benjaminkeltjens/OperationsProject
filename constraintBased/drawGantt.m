function [gate_stages, gap_duration] = drawGantt(solution)
    timetable = [solution.tow0stage1, solution.tow1stage1, solution.tow1stage2, solution.tow2stage1, solution.tow2stage2, solution.tow2stage3];
    
    N_active_stages = sum(solution.tow+1);
    
    gate_stages = zeros(solution.N_gates,1);
    for i = 1:solution.N_gates
        temp_gate_stages = find(solution.gates == i)';
        size_diff = length(temp_gate_stages) - size(gate_stages,2);
        if size_diff > 0
            gate_stages = [gate_stages, zeros(solution.N_gates, size_diff)];
        end
        ordered_gate_stages = orderGateStages(temp_gate_stages, timetable,solution.tow);
        gate_stages(i,1:length(temp_gate_stages)) = ordered_gate_stages;
    end
    
    gap_duration = zeros(solution.N_gates,size(gate_stages,2)*2);
    
    for i = 1:solution.N_gates
        for j = 1:length(find(gate_stages(i,:)))
            if j == 1
                 [time_since_prev_stage, curr_stage_length] = mapTowGateToLength(gate_stages(i,j),0,timetable,solution.tow);
            else
                [time_since_prev_stage, curr_stage_length] = mapTowGateToLength(gate_stages(i,j),gate_stages(i,j-1),timetable,solution.tow);
            end
            gap_duration(i,(j*2)-1:j*2) =  [time_since_prev_stage, curr_stage_length];
        end
    end
    
%     figure('Schedule');
    chart = barh(1:1:size(gap_duration,1), gap_duration*solution.dt, 'stacked');
    xlim([0, 1440])
    xticks(linspace(0, 1440, 13))
    xticklabels({'0:00','2:00','4:00','6:00','8:00','10:00','12:00','14:00','16:00','18:00','20:00','22:00','0:00'})
    yticks(1:1:solution.N_gates)
    xlabel('Time [HH:MM]');
    ylabel('Gate Number');    
    set(chart(1:2:size(chart, 2)), 'Visible', 'off');
    set(chart(2:2:size(chart, 2)), 'FaceColor', 'y');
    
    %% Add text
    % for each gate, go through each stage in gate
    % unpack index to text name.
    stage_map = [1, 0, 0; 2, 3, 0; 4, 5, 6];
    
    for j = 1:size(gate_stages,1)
        stages = gate_stages(j,:);
        if sum(stages) ~= 0
            non_zero_s = nonzeros(stages); 
            for s = 1:length(non_zero_s)
                [aircraft,stage] = unwrapGates(non_zero_s(s), solution.N_aircraft);

                tow = solution.tow(aircraft);
                opt_stage = stage_map(tow+1, stage);
                start = timetable(aircraft, (opt_stage*2)-1);

                name = sprintf('i:%03d s:%01d',aircraft,stage);
                text(start*solution.dt+1, j, name,'FontSize',9)
            end
        end
    end
    
    
end

function [row, col] = unwrapGates(total_ind, N_aircraft)
    row = mod(total_ind,N_aircraft);
    if row == 0
        row = N_aircraft;
    end
    col = ((total_ind - row)/N_aircraft)+1;
end

function [time_since_prev_stage, curr_stage_length] = mapTowGateToLength(curr_total_index,prev_total_index,timetable,tows)
    stage_map = [1, 0, 0; 2, 3, 0; 4, 5, 6];
    [aircraft_1, stage_1] = unwrapGates(curr_total_index, size(timetable,1));
    tow_1 = tows(aircraft_1);
    opt_stage_1 = stage_map(tow_1+1, stage_1);
    start_1 = timetable(aircraft_1, (opt_stage_1*2)-1);
    stage_length_1 =  timetable(aircraft_1, opt_stage_1*2)-start_1;
    
    if prev_total_index ~= 0
        [aircraft_0, stage_0] = unwrapGates(prev_total_index, size(timetable,1));
        tow_0 = tows(aircraft_0);
        opt_stage_0 = stage_map(tow_0+1, stage_0);
        end_0 = timetable(aircraft_0, (opt_stage_0*2)) ;

        time_since_prev_stage = start_1 - end_0;
        curr_stage_length = stage_length_1;

    else
        time_since_prev_stage = start_1;
        curr_stage_length = stage_length_1;
    end
    
end

function ordered_array = orderGateStages(unordered_array, timetable,tows)
    stage_map = [1, 0, 0; 2, 3, 0; 4, 5, 6];
    % Make array of start time for each one
    start_times = zeros(1,length(unordered_array));
    ordered_array = zeros(1,length(unordered_array));
    
    
    for i = 1:length(unordered_array)
        [aircraft, stage] = unwrapGates(unordered_array(i), size(timetable,1));
        tow = tows(aircraft);
        opt_stage = stage_map(tow+1, stage);
        start_times(i) = timetable(aircraft, (opt_stage*2)-1);
    end
    ordered_time = sort(start_times);
    unique_ordered = unique(ordered_time);
    
    for i = 1:length(unique_ordered)
        count = 0;
        index = find(start_times == ordered_time(i));
        if length(index) == 1
            ordered_array(i+count) = unordered_array(index);
        else
            for j = 1:length(index)
                ordered_array(i+count+j-1) = unordered_array(index(j));
            end
            count = count + length(index) - 1;
        end
    end
end