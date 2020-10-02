function imgN_uint8 = normLHE(img,M,N,g) 
% imgN_uint8 = normLHE(img,M,N,g) provides an image by applying 
% local normalization techniques, Histogram equalization using M x N windows
% VARIABLES:
%   Inputs:
%       img         = input image                               
%       M , N       = window size
%   Output:
%       imgN_uint8 = normalized image 

% The equalization process can be performed locally, using image windows,
% Since the same pixel is involved in several windows, 
% the result is averaged out, which is more costly in computation terms.
%__________________________________________
% HISTORY:                                                    
%       +Date:      14/05/2016                          
%       +Author:    Saenz Jhon
%       +Version:   1.0                    
%       +Changes:   -               
%       +Description: -                                 
%__________________________________________

imgN_uint8=img;  
  
% Window size 
%M=3;
%N=3;
mid_val=round((M*N)/2);
% finds the number of rows and columns that are filled with ZERO
in=0;
for i=1:M
    for j=1:N
        in=in+1;
        if(in==mid_val)
            PadM=i-1;
            PadN=j-1;
            break;
        end
    end
end
% filled in the sides of the image with zeros 

B=padarray(img,[PadM,PadN]);

for i= 1:size(B,1)-((PadM*2)+1)
    
    for j=1:size(B,2)-((PadN*2)+1)
        cdf=zeros(256,1);
        inc=1;
        for x=1:M
            for y=1:N
                %finds the element in the centre of the window         
                if(inc==mid_val)
                    ele=B(i+x-1,j+y-1)+1;
                end
                    pos=B(i+x-1,j+y-1)+1;
                    cdf(pos)=cdf(pos)+1;
                   inc=inc+1;
            end
        end                      
        %calculate the CDF with the values in the window
        for l=2:256
            cdf(l)=cdf(l)+cdf(l-1);
        end
            imgN_uint8(i,j)=round(cdf(ele)/(M*N)*255);
     end
end
%if g = 1, plot the result images

  if g ==1
     collage = figure(3);
     collage.Name='Local Histogram Equalization';
     collage.NumberTitle='off';
     collage.Position=[566,400,560,420];
     subplot(2,2,1) 
     imshow (img); 
     title('Image raw');

     subplot(2,2,2) 
     imshow (imgN_uint8); 
     title('normalized image (LHE)');

     subplot(2,2,3) 
     imhist(img); 
     title('Non-Equalized Histogram');
     subplot(2,2,4) 
     imhist(imgN_uint8);
     title('Histogram with Local Equalization'); 
  end


    
    