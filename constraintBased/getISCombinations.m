function i_s_combinations = getISCombinations(stage_presence,t)
    C = find(stage_presence(:,t));
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
