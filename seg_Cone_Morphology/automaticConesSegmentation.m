function [BW, BW1] = automaticConesSegmentation(img)
% automaticConesSegmentation

%%  ultimos cambios 
%img = imadjust ( img) ;
%% variables iniciales
bw=zeros(size(img));
imgNorm=bw;
%% Lectura de los archivos de config
[search,fine,thr,thrNorm,Norm,dirImg_ref,false_pos,dirMask,width,height,angle,xo,yo] = textread('config\config.dat','%s %s %s %s %s %s %s %s %s %s %s %s %s', 2);
%imgRef=imread(strcat('config\imgRef.tif'));
%% si la normalización utiliza una imagen de referencia
if (Norm{2,1} == '3')||(Norm{2,1} == '5')
    imgRef=imread(dirImg_ref{2,1});
end

switch str2double(Norm{2,1})
    case 1 % Ajuste De Intensidad
        %imgNorm = filt_Avg_Lapl( img )
        imgNorm = imadjust(img, stretchlim (img), []);
        %imgNorm = imadjust ( img) ;
    case 2 % Ecualización de Histograma
        n = 256 ; %n niveles
        imgNorm=histeq(img,n);
    case 3 % Correspondencia de Histograma
        if any(imgRef)
            imgNorm= HMatch(img,imgRef, 2000,0);%técnica global de normalización usando Correspondencia de Histograma
        end
    case 4 % Ecualización del histograma por ventanas
        imgNorm = normLHE(img,25,25,0);
        
    case 5 % Corrección Gamma
        if any(imgRef)
            imgNorm = normGIC(img,imgRef,0);
        end
end
%% segmentación
% la busqueda de los valores thr y thrNorm es normalizada?
if (search{2,1} == '1')  % encuentra los valores apartir del valor de fine
    fineV=str2double(fine{2,1});
    [thr_, thrNorm_] = searchH(img,imgNorm,fineV);
    thr_=thr_+0.01;
    thrNorm_=thrNorm_+0.02;
else % usa los valores en config.dat
    thr_= roundn(str2double(thr{2,1}),-3); %
    thrNorm_=roundn(str2double(thrNorm{2,1}),-3);%
end

% segmentación H-min sin normalizar
bw=segmImExtMin( img,thr_,26,0); % ( I,h,conn,figure )
% segmentación H-min normalizada
bwNorm=segmImExtMin( imgNorm,thrNorm_,26,0);% ( I,h,conn,figure )

% segmentación Niveles de gris
bwAut = segmGrayLevels( imgNorm,2,0);% (I,levels,figure)
% Segmentación usando el algoritmo Kmeans
%[Ifc,CI] = fuzzycmeans(INorm,2,5,4);
%bwK_means = (Ifc==1);

% imshow([bw bwNorm bwAut]);

% comparar la relacion entre segmentaciones
BW = comparing(bwAut, bw, bwNorm, 0);

%% se han utilizado componentes conectados?
if str2double(false_pos{2,1})
    Mask=(imbinarize(imread(dirMask{2,1})));%% máscara  generada con segmentacionCones.m
    Mask=Mask(:,:,1); 
    %   figure (2)
    %   imshowpair(Mask,BW);
    BW = (  BW | Mask  ); %% Elimina en BW lo que aparece en la máscara
    %   figure (3)
    %   imshow(BW);
    [BW, ~]= clean_regions(BW,0); %% Elimina objetos pequeños usando componentes conectados
end
%% prueba de cc, si no se ha eliminado con la mascara realizar una nueva busqueda de elementos pequeños
%[BW Mask]= regiones(BW,0);%% corregir en regiones.m lo de eliminar el
%recuadro completo

%% imagen sin rotar
imshowpair(img,BW);
BW1=BW;
%% redimensiona y rota la imagen con los parametros suministrados
% si se pasa angle = 0, saldra una interfaz para pasar buscar graficamente
% los parametros de rotación. 
% la traslacion de la imagen sera indicando un determinado pixel que sera el punto de referencia y se ubicara 
% en el centro de la parte inferior de la nueva imagen redimensionada 
[BW,~,~,~]  = newSizeImg( BW,str2double(width{2,1}),str2double(height{2,1}),0 ,str2double(angle{2,1}),str2double( xo{2,1}),str2double( yo{2,1}));

%BW = newSizeImg( BW,400,400 );
% %imshow([ab,ac,bc,BW]);
% figure (4)
% imshow(BW);

%%
