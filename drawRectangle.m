%DRAWRECTANGLE draw a rectangle in the given image.
%   Detailed explanation goes here

function img_rect = drawRectangle(img, left_top, right_bot, line_width, line_color)

if ~exist('line_width', 'var') || isempty(line_width)
    line_width = 1;
end

if ~exist('line_color', 'var') || isempty(line_color)
    line_color = 0;
end

img_rect = img;

up_row = left_top(1);
left_col = left_top(2);
bot_row = right_bot(1);
right_col = right_bot(2);

% Top Line
img_rect(up_row:up_row+line_width-1, left_col:right_col) = line_color;

% Bottom Line
img_rect(bot_row-line_width+1:bot_row, left_col:right_col) = line_color;

% Left Line
img_rect(up_row:bot_row, left_col:left_col+line_width-1) = line_color;

% Right Line
img_rect(up_row:bot_row, right_col-line_width+1:right_col) = line_color;

end

