function imgN = normGIC(img, imgRef,g) 
%imgN = normGIC(img, imgRef) 
% Provides an image by applying global light normalisation techniques: 
% Gamma Intesity Correction
% VARIABLES:
%   Inputs:
%       img     = Input image                               
%       imgRef  = Reference image (correctly illuminated image)
%   Output:
%       imgN_uint8 = normalized image 

%Global Techniques: Gamma Intesity Correction
% The values of the pixels change exponentiallY,
% The value that should minimize the square difference from a model face:
% The value that minimizes this difference is estimated using the technique
% called Golden Section Search fminbnd, 
% which combines gold section search and parabolic interpolation. 
% [Xmin, FVAL] = fminbnd (function, x1, x2)
% Gamma intensity correction ( GIC ) compensates for changes in the overall
% brightness of an image. It transforms the pixel values of the image by 
% exposure in order to better adapt to a canonically lit image. 
% Formally, given an I image and a canonically lit IC image, 
% the gamma intensity corrected I¤ image is defined as follows:
% _________________________________________
% HISTORY:                                                    
%       +Date:      14/05/2016                          
%       +Author:    Saenz Jhon
%       +Version:   1.0                    
%       +Changes:   -               
%       +Description: -                                 
%__________________________________________
%   imgRef  = double(imread ('\imgCaras\000001_m-001-5.pgm'));
%   img= double(imread('\imgCaras\000000_m-001-2.pgm'));
img  = double(img);
imgRef  = double(imgRef);

if size(img)~= size(imgRef)
[x, y] = size(img);
%[xr, yr]=size(imgRef);
% imgRef=imcrop(imgRef,[(yr/2 -y) (xr/2 - x/2) y-1 x-1]);
imgRef=imresize(imgRef, [x y]);  
size(imgRef) 
end
% [fil,col]=size(img(:,:,1));
% vecImg= reshape(img(:,:,1)',fil*col,1);
% vecImgRef= reshape(imgRef(:,:,1)',fil*col,1);
% f=@(g)sum(((vecImg.^(1/g))-(vecImgRef(:,:,1))).^2)

f=@(g)sum(sum(((img.^(1/g))-(imgRef(:,:,1))).^2));
[gamma,fval] = fminbnd(f,0,2);
img=im2uint8(mat2gray(img));
%imgRef=im2uint8(mat2gray(imgRef));
imgN=imadjust(img,[],[],1/gamma);

%% PLOT 
if g ==1
     collage = figure(3);
     collage.Name='Gamma Intesity Correction';
     collage.NumberTitle='off';
     collage.Position=[566,400,560,420];
     subplot(2,2,1) 
     imshow (img); 
     title('Image raw');

     subplot(2,2,2) 
     imshow (im2uint8(mat2gray(imgRef))); 
     title('Reference Image');

     subplot(2,2,3) 
     imshow (imgN); 
     title('Normalized Image(GIC)');
     subplot(2,2,4) 
     plot((0:0.01:1).^(1/gamma));axis tight;
     title(strcat('gamma 1/(', num2str(gamma), ')')) 
end

end
     