% Computes motion vectors using conjugate search method
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
% Written by zcx

function [motionVector, CScomputations, time] = motionEstCS(imgP, imgI, mbSize, p)
tic

imgI = double(imgI);
imgP = double(imgP);

[row, col] = size(imgI);

vectors = zeros(2, row * col / mbSize^2);
costs = ones(3, 3) * 65537;

computations = 0;
mbCount = 1;
for i = 1 : mbSize : row-mbSize+1
    for j = 1 : mbSize : col-mbSize+1
        
        % Display the target macroblock
        imgP_rect = drawRectangle(imgP, [i, j], [i+mbSize-1, j+mbSize-1], 1, 255);
        subplot(1, 2, 1);
        imshow(uint8(imgP_rect), 'InitialMagnification', 'fit');
        title('Target Frame')
        
        img = double(imgI);
        color = 0;
        
        
        costs(2, 2) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
            imgI(i:i+mbSize-1,j:j+mbSize-1),mbSize);
        
        if(j>1)
            costs(2,1) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), imgI(i:i+mbSize-1,j-1:j-1+mbSize-1), mbSize);
        end
        
        if(j<col-mbSize+1)
            costs(2,3) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), imgI(i:i+mbSize-1,j+1:j+1+mbSize-1), mbSize);
        end
            
        x = j;        
        while (costs(2,1) < costs(2,2) || costs(2,3) < costs(2,2))
            if(costs(2,1) < costs(2,3))
                costs(2,2) = costs(2,1);
                x = x - 1;
                if(x<1)
                    break;
                end
                costs(2,1) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), imgI(i:i+mbSize-1,x:x+mbSize-1), mbSize);
            else 
                costs(2,2) = costs(2,3);
                x = x + 1;
                if(x>col-mbSize+1)
                    break;
                end
                costs(2,3) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), imgI(i:i+mbSize-1,x:x+mbSize-1), mbSize);
            end
            computations = computations + 1;
            
            img = drawRectangle(img, [i, x], [i+mbSize-1, x+mbSize-1], 1, color);
            color = color + 25;
            subplot(1, 2, 2);
            imshow(uint8(img), 'InitialMagnification', 'fit');
            title('Reference Frame');
            pause(0.5);
        end
                
        if(i>1)
            costs(1,2) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), imgI(i-1:i-1+mbSize-1,x:x+mbSize-1), mbSize);
        end
        
        if(i<row-mbSize+1)
            costs(3,2) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), imgI(i+1:i+1+mbSize-1,x:x+mbSize-1), mbSize);
        end
        
        y = i;
        while (costs(1,2) < costs(2,2) || costs(3,2) < costs(2,2))
            if(costs(1,2) < costs(3,2))
                costs(2,2) = costs(1,2);
                y = y - 1;
                if(y<1)
                    break;
                end
                costs(1,2) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), imgI(y:y+mbSize-1,x:x+mbSize-1), mbSize);
            else 
                costs(2,2) = costs(3,2);
                y = y + 1;
                if(y>row-mbSize+1)
                    break;
                end
                costs(2,3) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), imgI(y:y+mbSize-1,x:x+mbSize-1), mbSize);
            end
            computations = computations + 1;

            img = drawRectangle(img, [y, x], [y+mbSize-1, x+mbSize-1], 1, color);
            color = color + 25;
            subplot(1, 2, 2);
            imshow(uint8(img), 'InitialMagnification', 'fit');
            title('Reference Frame');
            pause(0.5);
        end
        
        vectors(1, mbCount) = y - i;
        vectors(2, mbCount) = x - j;
        
        mbCount = mbCount + 1;
%         
%             
%         hor_index = j;
%         ver_index = i;
%         
%         cost_min = 65537;
%         
%         for hor = 1 : col-mbSize+1
%             cost = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1),imgI(i:i+mbSize-1,hor:hor+mbSize-1), mbSize) + abs(hor - j);
%             if(cost < cost_min)
%                 hor_index = hor;
%                 cost_min = cost;
%             end
%             computations = computations + 1;
%             
%             img = drawRectangle(img, [ver_index, hor], [ver_index+mbSize-1, hor+mbSize-1], 1, color);
%             color = color + 25;
%             subplot(1, 2, 2);
%             imshow(uint8(img), 'InitialMagnification', 'fit');
%             title('Reference Frame');
%             pause(0.5);
%         end
%         
%         for ver = 1 : row-mbSize+1
%             cost = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1),imgI(ver:ver+mbSize-1,hor_index:hor_index+mbSize-1), mbSize) + abs(ver - i);
%             if(cost < cost_min)
%                 ver_index = ver;
%                 cost_min = cost;
%             end
%             computations = computations + 1;
%             
%             img = drawRectangle(img, [ver, hor_index], [ver+mbSize-1, hor_index+mbSize-1], 1, color);
%             color = color + 25;
%             subplot(1, 2, 2);
%             imshow(uint8(img), 'InitialMagnification', 'fit');
%             title('Reference Frame');
%             pause(0.5);
%         end
%         
        % Display the selected macroblock
%         imgI_rect = drawRectangle(imgI, [ver_index, hor_index], [ver_index+mbSize-1, hor_index+mbSize-1], 1, 255);
%         subplot(1, 2, 2);
%         imshow(uint8(imgI_rect), 'InitialMagnification', 'fit');
%         title('Reference Frame');
%         pause(0.1);
%         
%         vectors(1, mbCount) = ver_index-i;
%         vectors(2, mbCount) = hor_index-j;
%         
%         mbCount = mbCount + 1;
    end
end

motionVector = vectors;
CScomputations = computations / (mbCount - 1);
time = toc;
end

