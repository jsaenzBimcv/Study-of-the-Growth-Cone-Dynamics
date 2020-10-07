function [thrOut, thrNorm] = searchH(img,imgNorm,fine)
% searchH
% searches for threshold values to be used in extended-minimum transform
%
% img      - Input image.
% imgNorm  - Input normalized image
% fine     - Step length for the search of the optimal value
% thrOut   - Optimal Input image threshold 
% thrNorm  - Optimal threshold for the normalized image

%--------------------------------------------------------------------------
cnt=1;
x=(0:fine:1);
cntPxB = zeros(1,numel(x)); 
cntPxB1 = zeros(1,numel(x));

for thr = 0:fine:1
    bw=segmImExtMin( img,roundn(thr,-3),26,0); % ( I,h,conn,figure )
    bw1=segmImExtMin( imgNorm,roundn(thr,-3),26,0); 
    %imshow(bw);
    cntPxB(cnt)= (nnz(bw)/numel(bw)); 
    cntPxB1(cnt)= (nnz(bw1)/numel(bw1));
    cnt=cnt+1;
end
x=(0:fine:1);
orden=3;
% f1= diff(cntPxB); % finding the relative highs and lows
f12=diff(cntPxB,orden); % finding the turning points

% f1(end+1)=0;
for o= 1:1:orden
    % filled with zeros according to the order of the derivative
    f12(end+1)=0; %#ok<*AGROW>
end

%[peak_value, peak_location] = findpeaks(f1); %Find spikes
[peak_value, peak_location] = findpeaks((f12),'minpeakheight', ...
    max((f12))*0.8);% Look for peaks of a minimum height

% target threshold with the highest value of the higher order derivative
loc=peak_location(find(ismember(peak_value,max(peak_value)))); %#ok<FNDSB>
thrOut = x(loc);% threshold value of the transform H
% If the target found is greater than 99% of white pixels 
% it means that there is nothing in the segmentation, 
% so the next highest value of white pixels is taken
if cntPxB(loc)> 0.997 
    [~, c]=size(peak_value);
    if c > 1
        loc=peak_location(find(peak_value==max(peak_value))-1);
        thrOut = x(loc);
    else 
        % if you only find one peak you need to increase the search range
        [peak_value, peak_location]=findpeaks((f12),'minpeakheight',...
            max((f12))*0.1);       
        loc=peak_location(find(peak_value==max(peak_value))-1);
        thrOut = x(loc);
    end
    
end
%thr %is the target value for H-transfer in the unsegmented image

%% Search for maximums and minimums for the normalized image

% f2=diff(cntPxB1);% 1st derivative
% f2(end+1)=0;
f22=diff(cntPxB1,orden);% derived from higher order
for o= 1:1:orden
    % filled with zeros according to the order of the derivative
    f22(end+1)=0; 
end
[peak_value, peak_location] = findpeaks((f22),'minpeakheight',...
    max((f22))*0.8);
loc=peak_location(find(peak_value==max(peak_value))); %#ok<FNDSB> 
thrNorm = x(loc);
if cntPxB1(loc)> 0.997 
    [~, c]=size(peak_value);
    if c > 1
        loc=peak_location(find(peak_value==max(peak_value))-1);
        thrNorm= x(loc);
    else 
        [peak_value, peak_location] = findpeaks((f22),'minpeakheight',...
            max((f22))*0.1);       
        loc=peak_location(find(peak_value==max(peak_value))-1);
        thrNorm= x(loc);
    end
    
end
%thrNorm;

