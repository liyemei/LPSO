%  Creat_Image_space:函数创建影像尺度空间
%  Input:  
%           im：       是输入的原始图像;
%           layers：是构建的尺度空间的层数，这里没有使用下采样操作.
%           scale_value：影像的尺度缩比比例系数，默认是1.6;
%           sigma_1：是第一层的图像的尺度，默认是1.6，尺度空间第一层的图像由image经过标准差
%           sigma_2：是每次计算下一层图像之前，对之前层图像的高斯平滑标准差,默认是1不变
%           ratio：是相隔两层的尺度比
%  Output:
%              Nonelinear_Scalespace：是构建的影像尺度空间

function [Nonelinear_Scalespace]=Create_Image_space(im,Scale_Invariance,nOctaves,scale_value,...
                                                        sigma_1,sigma_2,...
                                                        ratio)
%% 默认参数设置
if nargin < 3
    nOctaves               = 3;          %  构建的影像金字塔层数.  
end
if nargin < 4
    scale_value       = 1.6;       %  影像尺度缩放系数   
end
if nargin < 5
    sigma_1           = 1.6;         %  第一层的图像的尺度，默认是1.6.
end
if nargin < 6
    sigma_2           = 1;            %  是每次计算下一层图像之前，对之前层图像的高斯平滑标准差.
end
if nargin < 7
     ratio               = 2^(1/3);   %  连续两层的尺度比
end

%% 将影像转换为灰度图
[~,~,num1]=size(im);
if(num1==3)
    dst=rgb2gray(im);
else
    dst=im;
end
% 将影像转换为浮点型影像，数值在[0~1]之间 
image=im2double(dst);
[M,N]=size(image);
%% 判断是否需要构建金字塔
if (strcmp(Scale_Invariance  ,'YES'))
    Layers=1;
else
    Layers=nOctaves;
end
%% 初始化非线性影像cell空间
Nonelinear_Scalespace=cell(1,Layers);
for i=1:1:Layers
    Nonelinear_Scalespace{i}=zeros(M,N);
end
%首先对输入图像进行高斯平滑
windows_size=2*round(2*sigma_1)+1;
W=fspecial('gaussian',[windows_size windows_size],sigma_1);      % Fspecial函数用于创建预定义的滤波算子
image=imfilter(image,W,'replicate');                                              %base_image的尺度是sigma_1  % 对任意类型数组或多维图像进行滤波。
Nonelinear_Scalespace{1}=image;                                                 %base_image作为尺度空间的第一层图像

%计算每层的尺度
sigma=zeros(1,Layers);
for i=1:1:Layers
    sigma(i)=sigma_1*ratio^(i-1);%每层的尺度
end

%% 构建非线性尺度空间
for i=2:1:Layers
    %之前层的非线性扩散后的的图像,计算梯度之前进行平滑的目的是为了消除噪声
    prev_image=Nonelinear_Scalespace{i-1};
    prev_image2=imresize(prev_image,1/scale_value,'bilinear');
    windows_size=2*round(2*sigma_2)+1;
    W=fspecial('gaussian',[windows_size,windows_size],sigma_2);
    Nonelinear_Scalespace{i}=imfilter(prev_image2,W,'replicate');
end
end
