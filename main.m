clc
clear 
close all

dst_method = {'Euclidean','Manhattan','Mahalanobis'};
descriptor = {'globalRGBHisto','PCA'};
show_output = 0; % set this to 1 to display image result

%% 1) experiment globalRGBHisto with rgb quantization from 1 to 20 - will take long
% rgb_quantization_map = zeros(1,20); 
% 
% for i=1:20
%     create_descriptor_globalRGBHisto(i);
%     [p,r,ap,map] = cvpr_visualsearch(dst_method{1},descriptor{1},show_output);
%     rgb_quantization_map(i)=round(map*100);
% end
% 
% plot(rgb_quantization_map);
% ylim([0 30])
% xlim([0 20])
% xlabel('Quantization')
% ylabel('Mean Average Precision (%)')
% title('RGB Quantization')
% grid on

%% 2) main test of globalRGBHisto with best performing q=5 and euclidean distance
% create_descriptor_globalRGBHisto(5);
% [p,r,ap,map] = cvpr_visualsearch(dst_method{1},descriptor{1},show_output);

%% 3) test globalRGBHisto with different distance measurements
% [p,r,ap,map] = cvpr_visualsearch(dst_method{2},descriptor{1},show_output); % Manhattan
% [p,r,ap,map] = cvpr_visualsearch(dst_method{3},descriptor{1},show_output); % Mahalanobis

%% 4) test PCA with globalRGBHisto quantization of 5 and different distance measures
% create_descriptor_PCA(5);
% [p,r,ap,map] = cvpr_visualsearch(dst_method{1},descriptor{2},show_output); % Euclidean
% [p,r,ap,map] = cvpr_visualsearch(dst_method{2},descriptor{2},show_output); % Manhattan
% [p,r,ap,map] = cvpr_visualsearch(dst_method{3},descriptor{2},show_output); % Mahalanobis





