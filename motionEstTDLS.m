% Computes motion vectors using 2-d logarithmic Search method
%
% Input
%   imgP : The image for which we want to find motion vectors
%   imgI : The reference image
%   mbSize : Size of the macroblock
%   p : Search parameter  (read literature to find what this means)
%
% Ouput
%   motionVect : the motion vectors for each integral macroblock in imgP
%
% Written by ...

function [motionVect, TDLScomputations, time] = motionEstTDLS(imgP, imgI, mbSize, p)
tic

imgI = double(imgI);
imgP = double(imgP);

[row, col] = size(imgI);

vectors = zeros(2, (row/mbSize)*(col/mbSize));
costs = ones(3, 3) * 65537;

computations = 0;

%calculating max levels based on search parameter and max step size
%calculation based on levels
levels = floor(log10(p+1)/log10(2));
stepmax = 2^(levels - 1);

mbCount = 1; % to keep track of the macro block count for the motion vector

for i = 1:mbSize:row-mbSize+1
    for j = 1:mbSize:col-mbSize+1
        
        % display the target macroblock
        imgP_rect = drawRectangle(imgP, [i, j], [i+mbSize-1, j+mbSize-1], 1, 255);
        subplot(1, 2, 1);
        imshow(uint8(imgP_rect), 'InitialMagnification', 'fit');
        title('Target');
        
        img = double(imgP);
        color = 0;
        
        % start from the top left pixel of each macro block
        x = j;
        y = i;
        
        %calculating center at very first and skipping this in while loop
        costs(2,2) = costFuncMAD(imgI(i:i+mbSize-1,j:j+mbSize-1), ...
            imgP(i:i+mbSize-1,j:j+mbSize-1),mbSize);
        
        computations = computations + 1;
        stepsize = stepmax;
        
        % to continue step search until stepsize becomes < 1
        
        while( stepsize >= 1)
            % m is row(vertical) index
            % n is col(horizontal) index
            % this means we are scanning in raster order
            for m = -stepsize : stepsize : stepsize
                for n = -stepsize : stepsize : stepsize
                    refBlkVer = y + m;
                    refBlkHor = x + n;
                    
                    %checking if macroblock around displaced coordinates goes out of image
                    %boundaries if so skip that iteration
                    if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row ...
                            || refBlkHor < 1 || refBlkHor+mbSize-1 > col ...
                            || m * n ~= 0) % Take only four searching macroblock
                        continue;
                    end
                                       
                    costRow = m/stepsize + 2;
                    costCol = n/stepsize + 2;
                    
                    if (costRow == 2 && costCol == 2)
                        continue
                    end
                    
                    costs(costRow , costCol) = costFuncMAD(imgI(i:i+mbSize-1 , j:j+mbSize-1)...
                        ,imgP(refBlkVer:refBlkVer+mbSize-1 , refBlkHor:refBlkHor+mbSize-1),mbSize);
                    
                    computations = computations + 1;
                    
                    % Display the searching macroblock
%                     imgI_rect = drawRectangle(imgI, [refBlkVer, refBlkHor], [refBlkVer+mbSize-1, refBlkHor+mbSize-1], 1, 0);
%                     subplot(1, 2, 2);
%                     imshow(uint8(imgI_rect), 'InitialMagnification', 'fit');
%                     title('Reference Frame');
%                     pause(0.1);

                    img = drawRectangle(img, [refBlkVer, refBlkHor], [refBlkVer+mbSize-1, refBlkHor+mbSize-1], 1, color);
                    color = color + 25;
                    subplot(1, 2, 2);
                    imshow(uint8(img), 'InitialMagnification', 'fit');
                    title('Reference Frame');
                    pause(0.5);
                
                end
            end
            
            
            [dx, dy, ~] = minCost(costs);
            
            %Assigning the coordinates with minimum cost or MAD as new center
            x = x + (dx - 2) * stepsize;
            y = y + (dy - 2) * stepsize;
            
            % updating stepsize if occured the center optimized macroblock
            % or boundary 
            if( (dx == 2 && dy == 2) ||  x <= 1 || x >= col ...
                    || y <= 1 || y >= row )
                stepsize = stepsize / 2;
                continue;
            end
            
            % Updating the center cost to minimum cost
            costs(2, 2) = costs(dy, dx);
        end
        
        vectors(1,mbCount) = y - i;    % row co-ordinate for the vector
        vectors(2,mbCount) = x - j;    % col co-ordinate for the vector
        
        % display the selected macroblock
%         subplot(1, 2, 2);
%         imgI_rect = drawRectangle(imgI, [i+vectors(1, mbCount), j+vectors(2, mbCount)], [i+vectors(1, mbCount)+mbSize-1, j+vectors(2, mbCount)+mbSize-1], 1, 255);
%         imshow(uint8(imgI_rect), 'InitialMagnification', 'fit');
%         title('Reference Frame');
%         pause(0.5);

        mbCount = mbCount + 1; % Incrementing Macro Block count
        costs = ones(3, 3) * 65537; %Resetting costs for next level of search
    end
%     disp(i);
%     disp(j);
end

motionVect = vectors;
TDLScomputations = computations/(mbCount - 1);
time = toc;

