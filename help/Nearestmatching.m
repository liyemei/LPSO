function [matchedPoints_1, matchedPoints_2]=Nearestmatching(position_1, position_2,descriptors_1,descriptors_2,scale_value,Scale_Invariance)
%% Nearest matching 
[indexPairs,~] = matchFeatures(descriptors_1,descriptors_2,'MaxRatio',1,'MatchThreshold',10);
matchedPoints1 = position_1(indexPairs(:, 1), :);
matchedPoints2 = position_2(indexPairs(:, 2), :);
disp('初始匹配点数目: '); disp(size(matchedPoints1,1));
if (strcmp(Scale_Invariance,'YES'))
    matchedPoints_1=  matchedPoints1;
    matchedPoints_2=  matchedPoints2;
else
    [matchedPoints_1,matchedPoints_2] = BackProjection(matchedPoints1,matchedPoints2,scale_value);  % ---反投影到原始尺度
end


end