function stage_presence = concurrentStages(aircraft_schedules,N_aircraft,dt)
    %index by i,s (i-1)*6+s
    stage_presence = zeros(N_aircraft*6,1440/dt);
    for i = 1:N_aircraft
        stage_presence(indexer(i,1),:) = timeTrueVector(aircraft_schedules.tow0stage1(i,:),dt);
        stage_presence(indexer(i,2),:) = timeTrueVector(aircraft_schedules.tow1stage1(i,:),dt);
        stage_presence(indexer(i,3),:) = timeTrueVector(aircraft_schedules.tow1stage2(i,:),dt);
        stage_presence(indexer(i,4),:) = timeTrueVector(aircraft_schedules.tow2stage1(i,:),dt);
        stage_presence(indexer(i,5),:) = timeTrueVector(aircraft_schedules.tow2stage2(i,:),dt);
        stage_presence(indexer(i,6),:) = timeTrueVector(aircraft_schedules.tow2stage3(i,:),dt);
    end
end

function index = indexer(i,s)
    index = (i-1)*6+s;
end

function array = timeTrueVector(begin_end,dt)
    array = [zeros(1,begin_end(1)-1), ones(1,begin_end(2)-begin_end(1)+1), zeros(1,(1440/dt)-begin_end(2))]; 
end