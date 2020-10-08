function BW = comparing(bw, bw1, bw2, g)
% COMPARING
% compares the pixels of 3 binary images, a new image is generated with 
% the pixels having the same value in at least two of the three images 
%% Boolean operations
BW = bw; % bwAut levels gray
BW2 = bw1;% bw Hmin
BW1 = bw2;% bwNorm Hmin Norm

ab = imbinarize(BW1 + BW);
ac = imbinarize(BW2 + BW);
bc = imbinarize(BW2 + BW1);

BW = and(ac , bc);
BW = or(BW, bc);
if g
    imshow([ab,ac,bc,BW]);
end