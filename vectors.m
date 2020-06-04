%% This script defines the gate matrix containing the distances from each gate to the entrance and the 'suitability' of the gate as described between lines 6 and 9 of this script. The gate matrix is defined by the variable 'gates_matrix'. In addition it defines also the towcost vector as specified below 

%% Note that this script needs the xlsx file 'JKIA data sheet to run'. 

%% Assumption: 5 types of gates are considered: international gates ('I'), domestic gates ('D'), short term ('ST', these are accessible with the bus (which is already taken into account into the gate to entrance times)), extra gates ('E') and long term parking ('CARGO'-these are the ones very far away for which you need two tows and you have unlimited availability).  


clc

weightvec = [[1 0 0], [0 1 0], [0 0 1]]; % [1 0 0] corresponds to B777, [0 1 0] corresponds to B737, [0 0 1] corresponds to E 190

towcost = 83.5; % towcost 
towcostvec = [towcost, 2*towcost, 3*towcost]; % towing costs for 0, 1 and 2 tows respectively. Here it is assumed that even for 0 tows you pay a fee since the aircraft still needs to be pushed back (and hence kind of towed) when departing 

%% creating a dictionary having as keys the gates and as valueset the distances from gate to entrance and the size of the gates themselves. 
%The size of the gates has to be read as follows: [1 1 1] means that the gate is suitable for all three types of aircraft;
%[0 1 1] means that the gate is suitable for B737 and E190 types of
%aircraft but not for B777s. [0 0 1] means that the gate is suitable only
%for the E190s.

keyset = {};

for i = 1:11
    
  %i = string(i) 
  keyvalue = strcat('I',string(i));
  keyset{end+1} = keyvalue;
  
end

for i = 1:8
    
    keyvalue = strcat('D',string(i));
    keyset{end+1} = keyvalue;
    
end

for i = 1:9
    
    keyvalue = strcat('ST',string(i));
    keyset{end+1} = keyvalue;
    
end
for i = 1:6
    
    keyvalue = strcat('E',string(i));
    keyset{end+1} = keyvalue;
    
end

keyset{end+1} = string('CARGO');
keyset = string(keyset);

keyset = keyset';

T = readtable('JKIA_data_sheet.xlsx','Sheet','Sheet2','ReadVariablenames',true);
times = T(1:35,3);
times = table2array(times);

T1 = readtable('JKIA_data_sheet.xlsx','Sheet','Sheet3');
gsize = T1(1:35,1:3);
gsize = table2array(gsize);


% valueset = cell(35,2);
% valueset1 = cell(35,1);
% 
% for i = 1:length(valueset)
%     
%     j = 1;
%     g_item = gsize(i,1:3);
%     valueset(i,j) = {times(i)};
%     valueset(i,j+1) = {g_item};
%     valueset1(i) = {[valueset(i,j),valueset(i,j+1)]}
% end

valueset = cell(35,1);
for i = 1:length(valueset)
    g_item = gsize(i,1:3);
    valueset(i) = {[times(i),g_item]};
end

gates = containers.Map(keyset,valueset);

%% I thought that working with a dictionary is not handy for you so then I also made a matrix. each row corresponds to a specific gate: the first column reports the times from the gate to the entrance, 
% while the other three columns correspond to the " suitabililty " of the
% gates as described in the previous section.

gates_matrix = ones ( 35 ,4 );

 for i = 1:length(valueset)
     
     gates_matrix(i,1) = times(i);
     gates_matrix(i,2:4) = gsize(i,1:3);

 end

