function [ClearPoints_1,ClearPoints_2] = BackProjection(InteriorPoints1,InteriorPoints2, scale_value)

% scale_value=1.6;               % 尺度缩放比例值

N=max(InteriorPoints1(:,3));       % 计算出当前特征点最大层数
M=max(InteriorPoints2(:,3));       % 计算出当前特征点最大层数
Key_nums1=size(InteriorPoints1,1); % 特征点的数目
Key_nums2=size(InteriorPoints2,1);
Image_points_1=zeros(Key_nums1,3);
Image_points_2=zeros(Key_nums2,3);
for i=1:1:Key_nums1
    x=InteriorPoints1(i,1);                 %The horizontal coordinate of the feature point
    y=InteriorPoints1(i,2);                 %The vertical coordinate of the feature point
    L_layer=InteriorPoints1(i,3);            %The number of layers of feature points
    if(L_layer==1)
        x=x;
        y=y;
    else
        x=x*scale_value^(L_layer-1);
        y=y*scale_value^(L_layer-1);
    end
    Image_points_1(i,1)=x;%特征点列坐标，就是x
    Image_points_1(i,2)=y;%特征点行坐标，就是y
%     Image_points1(i,:)=[x,y,score_1];
end
% ClearPoints_1=round(Image_points_1);
ClearPoints_1=Image_points_1;
for j=1:1:Key_nums2
    xx=InteriorPoints2(j,1);                 %The horizontal coordinate of the feature point
    yy=InteriorPoints2(j,2);                 %The vertical coordinate of the feature point
    R_layer=InteriorPoints2(j,3);            %The number of layers of feature points
    if(R_layer==1)
        xx=xx;
        yy=yy;
    else
        xx=xx*scale_value^(R_layer-1);
        yy=yy*scale_value^(R_layer-1);
    end
%     Image_points2(j,:)=[xx,yy];
    Image_points_2(j,1)=xx;%特征点列坐标，就是x
    Image_points_2(j,2)=yy;%特征点行坐标，就是y
end
% ClearPoints_2=round(Image_points_2);
ClearPoints_2=Image_points_2;
end