function [thrOut thrNorm] = searchH(img,imgNorm,fine)
cnt=1;
for thr = 0:fine:1
    bw=segmImExtMin( img,roundn(thr,-3),26,0); % ( I,h,conn,figure )
    bw1=segmImExtMin( imgNorm,roundn(thr,-3),26,0); % ( I,h,conn,figure )
    %imshow(bw);
    cntPxB(cnt)= (nnz(bw)/numel(bw)); 
    cntPxB1(cnt)= (nnz(bw1)/numel(bw1));
    cnt=cnt+1;
end
x=[0:fine:1];
orden=3;
% f1= diff(cntPxB); % encontrando los maximos y minimos relativos
f12=diff(cntPxB,orden);% encontrando los puntos de inflexion

% f1(end+1)=0;
for o= 1:1:orden
    f12(end+1)=0;
end

%[peak_value, peak_location] = findpeaks(f1); %Encuentra picos
[peak_value, peak_location] = findpeaks((f12),'minpeakheight',max((f12))*0.8);% Busca picos de una altura mínima

% thershold objtivo con el valor mas alto de la derivada de orden superior
loc=peak_location(find(peak_value==max(peak_value)));%localización del objetivo
thrOut = x(loc);%valor umbral de la transformada H
% si el objetivo encontrado es mayor al 99% de pixeles blancos quiere decir
% que no hay nada en la segmentación, por lo que se toma el siguiente valor
% mas alto
if cntPxB(loc)> 0.997 % % de pixeles blancos
    [f c]=size(peak_value);
    if c > 1
        loc=peak_location(find(peak_value==max(peak_value))-1);
        thrOut = x(loc);
    else % si sólo econtro en pico es necesario aumentar el rango de busqueda
        [peak_value, peak_location] = findpeaks((f12),'minpeakheight',max((f12))*0.1)       
        loc=peak_location(find(peak_value==max(peak_value))-1);
        thrOut = x(loc);
    end
    
end
%thr %es el valor buscado para la transf H en la img sin segmentar

%% busqueda de maximos y minimos para la imagen normalizada

% f2=diff(cntPxB1);% 1era derivada
% f2(end+1)=0;
f22=diff(cntPxB1,orden);% derivada de orden superior
for o= 1:1:orden
    f22(end+1)=0; % relleno con ceros según el órden de la derivada
end
[peak_value, peak_location] = findpeaks((f22),'minpeakheight',max((f22))*0.8);% Busca picos de una altura mínima
% thershold objtivo con el valor mas alto de la derivada de orden superior
loc=peak_location(find(peak_value==max(peak_value)));%localización del objetivo
thrNorm = x(loc);%valor umbral de la transformada H
% si el objetivo encontrado es mayor al 99% de pixeles blancos quiere decir
% que no hay nada en la segmentación, por lo que se toma el siguiente valor
% mas alto
if cntPxB1(loc)> 0.997 % % de pixeles blancos
    [f c]=size(peak_value);
    if c > 1
        loc=peak_location(find(peak_value==max(peak_value))-1);
        thrNorm= x(loc);
    else % si sólo econtro en pico es necesario aumentar el rango de busqueda
        [peak_value, peak_location] = findpeaks((f22),'minpeakheight',max((f22))*0.1)       
        loc=peak_location(find(peak_value==max(peak_value))-1);
        thrNorm= x(loc);
    end
    
end
%thrNorm;%es el valor buscado para la transf H en la img sin segmentar

