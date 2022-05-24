function [hist,max_value]=Hist_Oritation(x,y,scale,gradient,angle,n)

%% ������ʼ������������뾶
radius=round(6*scale);%����Բ�뾶
sigma=2*scale;%��˹��Ȩ������׼��
[M,N,~]=size(gradient);
radius_x_left=x-radius;
radius_x_right=x+radius;
radius_y_up=y-radius;
radius_y_down=y+radius;

%% ��ֹ����Խ��
if(radius_x_left<=0)
    radius_x_left=1;
end
if(radius_x_right>N)
    radius_x_right=N;
end
if(radius_y_up<=0)
    radius_y_up=1;
end
if(radius_y_down>M)
    radius_y_down=M;
end
%% ��ʱ������x,y�ھ����е�λ����
center_x=x-radius_x_left+1;
center_y=y-radius_y_up+1;

%% ������������Χ�������ص��ݶȺͷ���
sub_gradient=gradient(radius_y_up:radius_y_down,radius_x_left:radius_x_right);
sub_angle=angle(radius_y_up:radius_y_down,radius_x_left:radius_x_right);
W=sub_gradient;
bin=round(sub_angle*n/360);%ȷ������ֱ��ͼ���ĸ�BIN

%ֱ��ͼԲ��ѭ��
bin(bin>=n)=bin(bin>=n)-n;
bin(bin<0)=bin(bin<0)+n;

%% ����ֱ��ͼ
temp_hist=zeros(1,n);
[row,col]=size(sub_angle);
for i=1:1:row
    for j=1:1:col
        %������Բ������
        if(((i-center_y)^2+(j-center_x)^2)<=radius^2)
            temp_hist(bin(i,j)+1)=temp_hist(bin(i,j)+1)+W(i,j);
        end
    end
end

hist=zeros(1,n);
hist(1)=(temp_hist(35)+temp_hist(3))/16+...
    4*(temp_hist(36)+temp_hist(2))/16+temp_hist(1)*6/16;
hist(2)=(temp_hist(36)+temp_hist(4))/16+...
    4*(temp_hist(1)+temp_hist(3))/16+temp_hist(2)*6/16;

%Ч�ʸ�
hist(3:n-2)=(temp_hist(1:n-4)+temp_hist(5:n))/16+...
4*(temp_hist(2:n-3)+temp_hist(4:n-1))/16+temp_hist(3:n-2)*6/16;

hist(n-1)=(temp_hist(n-3)+temp_hist(1))/16+...
    4*(temp_hist(n-2)+temp_hist(n))/16+temp_hist(n-1)*6/16;
hist(n)=(temp_hist(n-2)+temp_hist(2))/16+...
    4*(temp_hist(n-1)+temp_hist(1))/16+temp_hist(n)*6/16;

%%����ֱ��ͼ������ֵ
max_value=max(hist);



