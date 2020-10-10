    function [angles] = coord2angleVec(coord)
    % coord2angleVec
    % Calculate the angles between two vectors of three consecutive points 
    % in 2D space, the coordinates will be given in column vectors with 
    % the X coordinates first and then the Y coordinates.
    % _________________________________________________________________________
    %   VARIABLES: Input:
    %     coord = [ ax1 ax2  ... ax(n/2) ay1 ay1  ... ay(n/2)
    %               bx1 bx2  ... bx(n/2) by2 by2  ... by(n/2)
    %               .   .   .
    %               .   .   .
    %               .   .   .
    %               mx1 mx2  ... mx(n/2) my1 my2  ... my(n/2)]

    %               Salida :
    %     Angles = [    aA1 aA2  ... aA(n/2)
    %                   bA1 bA2  ... bA(n/2)
    %                   .   .   .
    %                   .   .   .
    %                   .   .   .
    %                   mA1 mA2  ... mA(n/2)
    %
    %    Nota: m = #Observations
    %          n = #variables (coordinates x = n/2 + y = n/2)
    %__________________________________________________________________________
    % HISTORY:                                                           %
    %       +Date: revised 07-02-2017 10:51:05            %
    %       +Author: Saenz Jhon J
    %       +Version: 1.0                                                  %
    %       +Changes: -                                                    %
    %__________________________________________________________________________
    % load('contours_E_2m_Control_01_01_03.mat')
    % contours=contours'
    %  coord =[4 6 6 2 2 5 4 1 1 4];

    [fil, c]= size(coord);
    limit=c/2;
    angles=zeros(fil,limit);

    x = coord(:,1:limit);
    y = coord(:,limit+1:c);
    %V1= [0 0 0];
    %V2= [0 0 0];
    %ang=[];
    for f= 1:fil
        for a=1:limit
            switch a
                case 1 % the first with the last
                    V1=[(x(f,limit)-x(f,a)),(y(f,limit)-y(f,a)),(0)];
                    V2=[(x(f,a+1)-x(f,a)),(y(f,a+1)-y(f,a)),(0)];
                case limit % The last one with the first one to close the curve
                    V1=[(x(f,a-1)-x(f,a)),(y(f,a-1)-y(f,a)),(0)];
                    V2=[(x(f,1)-x(f,a)),(y(f,1)-y(f,a)),(0)];
                otherwise
                    V1=[(x(f,a-1)-x(f,a)),(y(f,a-1)-y(f,a)),(0)];
                    V2=[(x(f,a+1)-x(f,a)),(y(f,a+1)-y(f,a)),(0)];
            end
            [~, ang] = ab2v(V1, V2);
            angles(f,a) =(180-ang) ;
        end
    end
    % %% Graphing a group, optional
    % obsN=1;
    % coordObsN = reshape(coord(obsN,:),limit,2);
    % figure
    % scatter3(coordObsN(:,1),coordObsN(:,2), angles(obsN,:),25, angles(obsN,:), 'filled')
    % xlabel('X')
    % ylabel('Y')
    % grid on
    % colorbar()
    % hold on
    % plot(coordObsN(:,1),coordObsN(:,2))
    % plot([coordObsN(250,1),coordObsN(1,1)],[coordObsN(250,2) coordObsN(1,2)])
    % axis ij;
    end

