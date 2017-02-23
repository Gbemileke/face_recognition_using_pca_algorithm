path='C:\Users\chait\Documents\pca_images\image';
training_set_length=4;
images=[];
mean_image=[];
for a = 1:training_set_length 
   curr_path=strcat(path,int2str(a),'.jpg');
   image=imread(curr_path);
   image=rgb2gray(image);
   image=reshape(image,[],1);
   images = [images,image];
   if a==1
       mean_image=image;
   else
       mean_image=mean_image+image;
   end
end
mean_image=mean_image/training_set_length;
for a=1:training_set_length
    
    images(:,a)=images(:,a)-mean_image;
end
images_transpose=transpose(images);
covariance=double(images_transpose)*double(images);

[v,d]=eig(covariance);
eigenfaces=[];
for a=1:training_set_length
    eigenfaces=[eigenfaces,double(images)*double(v(:,a))];
end
sol=[];
for a=1:training_set_length
    sol(:,a)=linsolve(double(eigenfaces),double(images(:,a)));
end
[filename,pathname]=uigetfile('*.jpg','Select the test image');
 
chosen_image= imread(fullfile(pathname,filename), 'jpg');

chosen_image=rgb2gray(chosen_image);
chosen_image=reshape(chosen_image,[],1);
chosen_image=chosen_image-mean_image;
chosen_image=double(chosen_image);
 
chosen_image_sol=linsolve(double(eigenfaces),chosen_image);
eucledian_distance=[];
for a=1:4
    eucledian_distance(:,a)=sum(sqrt((chosen_image_sol - sol(:,a)) .^ 2));
end
[M,I] = min(eucledian_distance);
fprintf('Chosen image matches to image %d ',I);