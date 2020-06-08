function index = towIndex(i,n)
    global N_aircraft;
    global N_gates;
    global N_steps;
    global N_stages;
    index = N_aircraft*N_stages*N_gates*N_steps + (i-1)*N_aircraft+n;
end