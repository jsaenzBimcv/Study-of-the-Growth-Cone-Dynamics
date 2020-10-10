function [m, a] = ab2v(v1, v2)
% Magnitude of vector is its norm
m(1) = norm(v1);
m(2) = norm(v2); 
% 
% % Min. angles from vector 1 to axes
% a(1 : 3) = acosd(v1 / m(1));
% % Min. angles from vector 2 to axes
% a(4 : 6) = acosd(v2 / m(2)); 

% Dot product dot(v1, v2) equals sum(v1 .* v2)
%  a(7) = acosd(dot(v1, v2) / m(1) / m(2)); 
%---------------------------------------
%The basic acos formula is known to be inaccurate for small angles
    %     a = (acosd(dot(v1, v2) / m(1) / m(2)));
    % otra forma de calcular el ángulo
    % theta = acos(dot(v1, v2) /(m(1)*m(2)));% en radianes
    % a2= 360*theta/(2*pi);%% En grados
% -----------------------------------------    
a = atan2d(norm(cross(v1,v2)),dot(v1,v2));