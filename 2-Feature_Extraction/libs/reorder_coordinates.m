function [ wf_reorder ] = reorder_coordinates (wf)
%reorder_coordinates 
% Reorders the coordinates relative to the farthest point on the axis and, 
% by default, the coordinates are anchored to the first point closest to y, 
% which is a problem in a time series, since at first the reference point 
% is one and at any time the value of another point decreases, 
% becoming the new starting point, which becomes an error.  
% Note that the rows are the ordered coordinates the first half X and 
% the next half Y columns, remarks

[nObs, nCoord]=size(wf);
wf_reorder = zeros(size(wf));
for i=1:nObs
    [~, indice] = max(wf(i,nCoord/2+1:nCoord));
    wf_reorder(i,:)=[wf(i,indice:nCoord/2), wf(i,1:indice-1),...
        wf(i,indice+nCoord/2+1:nCoord), wf(i,nCoord/2+1:indice+nCoord/2)];
    % move all x to 0, subtracting the value of x1 from the whole row x
    mover=wf_reorder(i,1:nCoord/2);
    d=mover(1,1);
    mover=mover(1,1:nCoord/2)-d;
    wf_reorder(i,1:nCoord/2)=mover(1,1:nCoord/2);
end

