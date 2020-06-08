function index = towIndex(i,n,N_aircraft,N_stages,N_gates)
    index = N_aircraft*N_stages*N_gates + (i-1)*3+n;
end