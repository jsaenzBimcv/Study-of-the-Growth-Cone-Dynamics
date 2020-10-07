function imgN_uint8 = HMatch(img, imgRef, n,g)  
%imgN_uint8 = HistEq(img)  
% Provides an image by applying global light normalisation techniques: 
% Histogram Correspondence
% VARIABLES:
%   Inputs:
%       img     = Input image                               
%       imgRef  = Reference image (correctly illuminated image)
%       n       = bins in the cumulative distribution function
%   Output:
%       imgN_uint8 = normalized image 

% Histogram Matching or Histogram Specification.
% The objective is to obtain an image with a histogram similar 
% to a specified one, (histogram of a well-lit image).
% first the THU(g) and TSU(g) mappings are calculated
% The definitive function would be: T(g) = TUS(THU(g)), 
% TUS(g) is the inverse of TSU(g)
% The image to be normalised is passed on and the image is well lit
%__________________________________________
% HISTORY:                                                    
%       +Date:      14/05/2016                          
%       +Author:    Saenz Jhon
%       +Version:   1.0                    
%       +Changes:   -               
%       +Description: -                                 
%__________________________________________

%     img = imread ('\corpus\g4.jpg');
%     imgRef = imread('\corpus\testG1.jpg');


%%    method 1
%     M =zeros ( 256 , 1 , 'uint8' );
%     hist1 = imhist(img);  % 
%     hist2 = imhist(imgRef(:,:,1));
%   
%     cdf1 = cumsum(hist1)/numel(img);  % ( CDF )
%     cdf2 = cumsum(hist2)/numel(imgRef);
%     %// Compute the mapping
%     for idx = 1 : 256
%         [~,ind] = min(abs(cdf1(idx) - cdf2));
%          M(idx) = ind-1;
%     end
%     Ihn = M(double(img)+1);
%%    method 2
% n = 65 ; 
Ihn = imhistmatch(img, imgRef(:,:,1),n);
imgN_uint8 = im2uint8(Ihn);
%%  plot

if g==1
     collage = figure(3);
     collage.Name='Histogram Correspondence';
     collage.NumberTitle='off';
     collage.Position=[566,400,560,420];

     subplot(3,2,1) 
     imshow (img); 
     title('Image raw');
     subplot(3,2,2) 
     imhist(img); 
     title('Histogram raw');
     subplot(3,2,3) 
     imshow (imgRef); 
     title('Reference Image');
     subplot(3,2,4) 
     imhist(imgRef(:,:,1)); 
     title('Reference Image Histogram');
     subplot(3,2,5) 
     imshow (imgN_uint8); 
     title('Normalized Image(HMatch)');
     subplot(3,2,6) 
     imhist(imgN_uint8); 
     title('Normalized Histogram');
end

end