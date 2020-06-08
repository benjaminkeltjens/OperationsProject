function index = varIndex(i,s,j,t)
    global N_aircraft;
    global N_gates;
    global N_stages;
    index = (i-1)*N_aircraft+(s-1)*N_stages+(j-1)*N_gates+t;
end
