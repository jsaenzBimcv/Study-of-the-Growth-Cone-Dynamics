function [ wf_reorder ] = reorder_coordinates (wf)
%reorder_coordinates 
%   Reordena las coordenadas con relacion al punto mas lejano en el eje y,
%   las coordenadas pordefecto estan ancladas al primer punto mas cercano
%   en y, lo cual es un problema en una serie temporal, ya que en un
%   principio el pto de ref es uno y en cualquier momento disminuye el
%   valor de otro pto convirtiendose en el nuevo pto, lo que no es real
%   tener en cuenta que las filas son las coordenadas ordenadas la primera
%   mitad X y la siguiente Y
%   columnas, observaciones
[nObs, nCoord]=size(wf);
wf_reorder = zeros(size(wf));
for i=1:nObs
    [~, indice] = max(wf(i,nCoord/2+1:nCoord));
    wf_reorder(i,:)=[wf(i,indice:nCoord/2), wf(i,1:indice-1),...
        wf(i,indice+nCoord/2+1:nCoord), wf(i,nCoord/2+1:indice+nCoord/2)];
     mover=wf_reorder(i,1:nCoord/2); % mover todas las x a 0, restando el valor de x1 a toda la fila x
     d=mover(1,1);
     mover=mover(1,1:nCoord/2)-d;
     wf_reorder(i,1:nCoord/2)=mover(1,1:nCoord/2);
end

