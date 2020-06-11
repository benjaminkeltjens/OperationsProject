function [slotarray] = stack(timearr,timedep)
% timearr and timedep are arrays 
slotoff = zeros(1,length(timedep));
sloton = zeros(1,length(timearr));

slotoff(1) = timearr(1);

for i = 2:length(timedep)
    slotoff(i) = timearr(i)-timedep(i-1);
    
    if timearr(i) == 0
        slotoff(i) = 0;
    end
end

for i = 1:length(timedep)
    sloton(i) = timedep(i)-timearr(i);
    
    if timedep(i) == 0 
        sloton(i) = 0;
    end
    
end

slotarray = zeros(1,2*length(timedep));
% disp (2*length(timedep));


for i = 1:length(slotarray)
    
    if i/2-floor(i/2) == 0
        index = i/2;
        slotarray(i) = sloton(index);
    else
        if i ==1
         index = 1;
         
        else
            
            index = (i+1)/2;
                %disp(index)
        end   
        
        slotarray(i) =slotoff(index);
    end

end

end