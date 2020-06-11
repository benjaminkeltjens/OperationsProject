function i_s_combinations = getISCombinations(stage_presence,t,buffer)
    C = [];
    for b = 1:buffer+1
        buffered_step = max(1, t-b+1);
        temp = find(stage_presence(:,buffered_step));
        C = addStages(temp, C);
    end
    i_s_combinations = zeros(length(C),2);
    for i = 1:length(C)
        i_s_combinations(i,:) = combinationIndex(C(i));
    end
end

function pair = combinationIndex(index)
    s = mod(index,6);
    i = (index-s)/6 + 1;
    pair = [i,s];
end

function C = addStages(new_stages, final_stages)
    C = final_stages;
    for i = 1:length(new_stages)
        if sum(final_stages == new_stages(i)) == 0
            C = [C;new_stages(i)];
        end
    end
    C = sort(C);
end
