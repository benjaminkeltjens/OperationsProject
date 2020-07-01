function [gate_def,gates_matrix] = deleter(nr,gate_def,gates_matrix)
% function deleting rows from the ORIGINAL matrix 
% nr = vector containing the numbers of the rows to delete; 
nr = sort(nr);
add = 0; 

for i = 1:length(nr)
   
    
    gate_def(nr(i)-add,:)=[];
    gates_matrix(nr(i)-add,:)=[];
    add = add + 1;
    
end

