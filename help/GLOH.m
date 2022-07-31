function [descriptor]=GLOH(gradient,angle,x,y,main_angle,d,n,Block,scale)

%% Calculate the direction cosine and direction sine that the feature point should rotate
cos_t=cos(-main_angle/180*pi);
sin_t=sin(-main_angle/180*pi);

%% Obtain the radius of the neighborhood and determine the calculation window of the descriptor.
[M,N]=size(gradient);
Neighborhood_window=Block/scale;
radius=round(min(Neighborhood_window,min(M,N)/3));

%% Get the position of the feature point neighborhood area.
radius_x_left=x-radius;
radius_x_right=x+radius;
radius_y_up=y-radius;
radius_y_down=y+radius;
%Prevent index out of bounds
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
%% At this time, the position of the feature point x, y in the rectangle is
center_x=x-radius_x_left+1;
center_y=y-radius_y_up+1;
%% Index the gradient and direction of the pixels in the area around the feature point. 
sub_gradient=gradient(radius_y_up:radius_y_down,radius_x_left:radius_x_right);
sub_angle=angle(radius_y_up:radius_y_down,radius_x_left:radius_x_right);
sub_angle=round((sub_angle-main_angle)*n/360);
sub_angle(sub_angle<=0)=sub_angle(sub_angle<=0)+n;
sub_angle(sub_angle==0)=n;

%% The position of the pixels around the feature point after rotation,
%----the position at this time is centered on the feature point (x, y).
X=-(x-radius_x_left):1:(radius_x_right-x);
Y=-(y-radius_y_up):1:(radius_y_down-y);
[XX,YY]=meshgrid(X,Y);
c_rot=XX*cos_t-YY*sin_t;        %The position of the rotated x coordinate.
r_rot=XX*sin_t+YY*cos_t;        %The position of the rotated y coordinate.

%% Calculate which logarithmic polar coordinate grid the rotated position belongs to.
log_angle=atan2(r_rot,c_rot);                                         %Get the logarithmic polar coordinate angle of surrounding pixels.
log_angle=log_angle/pi*180;                                         % Switch to -180-180
log_angle(log_angle<0)=log_angle(log_angle<0)+360; %Convert to 0-360 degree range.
log_amplitude=log2(sqrt(c_rot.^2+r_rot.^2));               %Get the logarithmic polar radius of surrounding pixels.

%Here the angle is divided into 8 parts according to an interval of 45 degrees.
log_angle=round(log_angle*d/360);
log_angle(log_angle<=0)=log_angle(log_angle<=0)+d;
log_angle(log_angle>d)=log_angle(log_angle>d)-d;
%% 径向区间数量 3
r1=log2(radius*0.73*0.25);
r2=log2(radius*0.73);
log_amplitude(log_amplitude<=r1)=1;
log_amplitude(log_amplitude>r1 & log_amplitude<=r2)=2;
log_amplitude(log_amplitude>r2)=3;
%Descriptor generation
dis = (2*d+1)*n;
temp_hist=zeros(1,dis);           %Here the descriptor is a 200-dimensional vector.
[row,col]=size(log_angle);       %Get the height and width of the rectangular area.
for i=1:1:row
    for j=1:1:col
        %Determine the range of the circular area.
       if(((i-center_y)^2+(j-center_x)^2)<=radius^2)
            angle_bin=log_angle(i,j);                        %   对数极坐标角 落在该区域 
            amplitude_bin=log_amplitude(i,j);          %   对数极半径落在那个区域 
            bin_vertical=sub_angle(i,j);                     %   3D直方图的第三维 
            Mag=sub_gradient(i,j);                           %   此时像素点的梯度值
            if(amplitude_bin==1)
                temp_hist(bin_vertical)=temp_hist(bin_vertical)+Mag;
            else
                temp_hist(((amplitude_bin-2)*d+angle_bin-1)*n+bin_vertical+n)=temp_hist(((amplitude_bin-2)*d+angle_bin-1)*n+bin_vertical+n)+Mag;
            end
        end
    end
end
temp_hist=temp_hist/sqrt(temp_hist*temp_hist');
temp_hist(temp_hist>0.2)=0.2;
temp_hist(temp_hist==0)=0.001;
temp_hist=temp_hist/sqrt(temp_hist*temp_hist');
descriptor=temp_hist;
end