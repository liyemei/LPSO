%  Creat_Image_space:��������Ӱ��߶ȿռ�
%  Input:  
%           im��       �������ԭʼͼ��;
%           layers���ǹ����ĳ߶ȿռ�Ĳ���������û��ʹ���²�������.
%           scale_value��Ӱ��ĳ߶����ȱ���ϵ����Ĭ����1.6;
%           sigma_1���ǵ�һ���ͼ��ĳ߶ȣ�Ĭ����1.6���߶ȿռ��һ���ͼ����image������׼��
%           sigma_2����ÿ�μ�����һ��ͼ��֮ǰ����֮ǰ��ͼ��ĸ�˹ƽ����׼��,Ĭ����1����
%           ratio�����������ĳ߶ȱ�
%  Output:
%              Nonelinear_Scalespace���ǹ�����Ӱ��߶ȿռ�

function [Nonelinear_Scalespace]=Create_Image_space(im,Scale_Invariance,nOctaves,scale_value,...
                                                        sigma_1,sigma_2,...
                                                        ratio)
%% Ĭ�ϲ�������
if nargin < 3
    nOctaves               = 3;          %  ������Ӱ�����������.  
end
if nargin < 4
    scale_value       = 1.6;       %  Ӱ��߶�����ϵ��   
end
if nargin < 5
    sigma_1           = 1.6;         %  ��һ���ͼ��ĳ߶ȣ�Ĭ����1.6.
end
if nargin < 6
    sigma_2           = 1;            %  ��ÿ�μ�����һ��ͼ��֮ǰ����֮ǰ��ͼ��ĸ�˹ƽ����׼��.
end
if nargin < 7
     ratio               = 2^(1/3);   %  ��������ĳ߶ȱ�
end

%% ��Ӱ��ת��Ϊ�Ҷ�ͼ
[~,~,num1]=size(im);
if(num1==3)
    dst=rgb2gray(im);
else
    dst=im;
end
% ��Ӱ��ת��Ϊ������Ӱ����ֵ��[0~1]֮�� 
image=im2double(dst);
[M,N]=size(image);
%% �ж��Ƿ���Ҫ����������
if (strcmp(Scale_Invariance  ,'YES'))
    Layers=1;
else
    Layers=nOctaves;
end
%% ��ʼ��������Ӱ��cell�ռ�
Nonelinear_Scalespace=cell(1,Layers);
for i=1:1:Layers
    Nonelinear_Scalespace{i}=zeros(M,N);
end
%���ȶ�����ͼ����и�˹ƽ��
windows_size=2*round(2*sigma_1)+1;
W=fspecial('gaussian',[windows_size windows_size],sigma_1);      % Fspecial�������ڴ���Ԥ������˲�����
image=imfilter(image,W,'replicate');                                              %base_image�ĳ߶���sigma_1  % ����������������άͼ������˲���
Nonelinear_Scalespace{1}=image;                                                 %base_image��Ϊ�߶ȿռ�ĵ�һ��ͼ��

%����ÿ��ĳ߶�
sigma=zeros(1,Layers);
for i=1:1:Layers
    sigma(i)=sigma_1*ratio^(i-1);%ÿ��ĳ߶�
end

%% ���������Գ߶ȿռ�
for i=2:1:Layers
    %֮ǰ��ķ�������ɢ��ĵ�ͼ��,�����ݶ�֮ǰ����ƽ����Ŀ����Ϊ����������
    prev_image=Nonelinear_Scalespace{i-1};
    prev_image2=imresize(prev_image,1/scale_value,'bilinear');
    windows_size=2*round(2*sigma_2)+1;
    W=fspecial('gaussian',[windows_size,windows_size],sigma_2);
    Nonelinear_Scalespace{i}=imfilter(prev_image2,W,'replicate');
end
end
