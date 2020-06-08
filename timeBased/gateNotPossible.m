function gate_array = gateNotPossible(i, gate_matrix, aircraft_list)

    aircraft = aircraft_list(i);
    gate_array = find(gate_matrix(:,aircraft+1))';
end