clear all;
clc;

I = imread('../Images/SeamCarving.jpg');
%vertical curving
for num_iter  = 1:100
    for num_vertical = 1:2
        [direction energy_sum] = verticalDirection(I);
        I = verticalCurve(direction,energy_sum,I);
    end
    [direction energy_sum] = horizontalDirection(I);
    I = horizontalCurve(direction,energy_sum,I);
end

%% only horizontal/vertical curving
% clear all;
% clc;
% 
% I = imread('SeamCarving.jpg');
% %vertical curving
% for num_iter  = 1:300
%     for num_vertical = 1:2
%         [direction energy_sum] = verticalDirection(I);
%         I = verticalCurve(direction,energy_sum,I);
%     end
% %     [direction energy_sum] = horizontalDirection(I);
% %     I = horizontalCurve(direction,energy_sum,I);
% end
