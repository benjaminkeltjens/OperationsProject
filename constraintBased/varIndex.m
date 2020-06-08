function index = varIndex(i,s,j,N_stages,N_gates)
    index = (i-1)*(N_stages*N_gates)+(s-1)*N_gates+j;
end
