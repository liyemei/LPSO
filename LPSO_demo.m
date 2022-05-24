%  ******* Code: ���ھֲ���λ��ȶ��������Ķ�Դͼ��ƥ�� (���ӵ�����ͼ\��������\�Ⱥ���\�ɼ���)******
% *********Name: Heterogeneous image matching based on local phase sharpness orientation  description: --LPSO
%  author: Created  in 2021/05/24.
%  *********************************************************
clear all;
close all;
warning('off');
addpath(genpath('help'));
addpath(genpath('export_fig'));
addpath(genpath('LPSO'));
%% 1 Import and display reference and image to be registered
file_image= '.\Images';
[filename,pathname]=uigetfile({'*.*','All Files(*.*)'},'Select Image',file_image);image_1=imread(strcat(pathname,filename));
[filename,pathname]=uigetfile({'*.*','All Files(*.*)'},'Select Image',file_image);image_2=imread(strcat(pathname,filename));
% image_2 = imrotate(image_2,20);
%% 2  Setting of initial parameters 
% Key parameters:
Path_Block=32;                   % ���������򴰿ڴ�С, Ĭ��ֵ�ǣ�32/42/56
K =0.15;                              % �ݶ��ںϵ�Ȩ��ϵ��, Ĭ��ֵ�ǣ�0.15
sigma_1=1.6;                       %The first level of scale, Ĭ��ֵ�ǣ�1.6
ratio=2^(1/3);                     % scale ratio;
Scale ='NO';
%% 3 Ӱ��ռ�
t1=clock;
disp('Start LPSO algorithm processing, please waiting...');
tic;
[nonelinear_space_1]=Create_Image_space(image_1,Scale);
[nonelinear_space_2]=Create_Image_space(image_2,Scale);
disp(['����Ӱ��߶ȿռ仨��ʱ�䣺',num2str(toc),'��']);
%% 4 ������ȡ
tic;
[KeyPts_1,gradient_1,angle_1]  =  LPSO_features(nonelinear_space_1,sigma_1,ratio,K,Scale);
[KeyPts_2,gradient_2,angle_2]  =  LPSO_features(nonelinear_space_2,sigma_1,ratio,K,Scale);
disp(['��������ȡ����ʱ��:  ',num2str(toc),' S']);
%% 5 GLOH Descriptor 
tic;
descriptors_1=Log_polar_descriptors(gradient_1,angle_1,KeyPts_1,Path_Block);                                     
descriptors_2=Log_polar_descriptors(gradient_2,angle_2,KeyPts_2,Path_Block); 
disp(['���������ӻ���ʱ��:  ',num2str(toc),'S']); 
%% 6 Nearest matching    
disp('Nearest matching')
[matchedPoints1,matchedPoints2]=Nearestmatching(descriptors_1.locs, descriptors_2.locs,descriptors_1.des,descriptors_2.des,sigma_1,Scale);
%% �ֲ��޳��㷨
disp('Outlier removal')
[H,rmse]=FSC(matchedPoints1,matchedPoints2,'affine',3);
Y_=H*[matchedPoints1(:,[1,2])';ones(1,size(matchedPoints1,1))];
Y_(1,:)=Y_(1,:)./Y_(3,:);
Y_(2,:)=Y_(2,:)./Y_(3,:);
E=sqrt(sum((Y_(1:2,:)-matchedPoints2(:,[1,2])').^2));
inliersIndex=E < 3;
clearedPoints1 = matchedPoints1(inliersIndex, :);
clearedPoints2 = matchedPoints2(inliersIndex, :);
uni1=[clearedPoints1(:,[1,2]),clearedPoints2(:,[1,2])];
[~,i,~]=unique(uni1,'rows','first');
clearedPoints1=clearedPoints1(sort(i)',:);
clearedPoints2=clearedPoints2(sort(i)',:);
disp('keypoints numbers of outlier removal: '); disp(size(clearedPoints1,1));
disp(['RMSE of Matching results: ',num2str(rmse),'  ����']);
figure; showMatchedFeatures(image_1, image_2, clearedPoints1(:,[1,2]), clearedPoints2(:,[1,2]), 'montage');
t2=clock;
disp(['LPSO�㷨ƥ���ܹ�����ʱ��  :',num2str(etime(t2,t1)),' S']);  