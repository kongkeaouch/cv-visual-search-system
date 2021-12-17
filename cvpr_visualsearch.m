function [p,r,ap,map] = cvpr_visualsearch(dst_method,descriptor,show_output)
%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = '/Users/kongkeaouch/Desktop/cv/MSRC_ObjCategImageDatabase_v2';

%% Folder that holds the results...
DESCRIPTOR_FOLDER = '/Users/kongkeaouch/Desktop/cv/descriptors';
%% and within that folder, another folder to hold the descriptors
%% we are interested in working with
DESCRIPTOR_SUBFOLDER = descriptor;

%% 1) Load all the descriptors into "ALLFEAT"
%% each row of ALLFEAT is a descriptor (is an image)

ALLFEAT=[];
ALLFILES=cell(1,0);
ctr=1;
allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    featfile=[DESCRIPTOR_FOLDER,'/',DESCRIPTOR_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    load(featfile,'F');
    ALLFILES{ctr}=imgfname_full;
    ALLFEAT=[ALLFEAT ; F];
    ctr=ctr+1;
end

% transpose all features for Mahalanobis distance measurement
t_allfeat = ALLFEAT.';

%% 2) Pick image to be the query
NIMG=size(ALLFEAT,1);           % number of images in collection

% 20 images comprised of 1 impage/class at position 12 (1_12, 2_12...)
queryimg_set = ["Cow","Tree","House","Plane","Cow 2","Person","Car","Bike","Sheep","Flower","Sign","Duck","Book","Chair","Cat","Dog","Road","Water","Person 2","Boat";
"303","354","384","414","444","474","504","534","564","3","35","65","99","129","159","183","213","243","273","333"];

colors = ["#004c6d","#A2142F","#4DBEEE","#f95d6a","#7E2F8E","#ff7c43","#665191","#2f4b7c","#d45087","#ffa600","#f09fa2","#de425b","#a05195","#D95319","#0072BD","#77AC30","#003f5c","#488f31","#EDB120","#346888"];

queryset_len = length(queryimg_set(1,:));

dst=zeros(NIMG,queryset_len);
p = zeros(queryset_len,NIMG);
r = zeros(queryset_len,NIMG);

n_relevant_img = zeros(1,queryset_len);
candidateimg = zeros(queryset_len,NIMG);

dst_n = 1;

% iterate over each image in query set for retrieval and evaluation
for qi=1:length(queryimg_set)
    %% 2) Pick image to be the query
    queryimg = str2double(queryimg_set(2,qi));
    queryimg_class = queryimg_set(1,qi);

    %% 3) Compute the distance of image to the query

    for i=1:NIMG
        candidate=ALLFEAT(i,:);
        query=ALLFEAT(queryimg,:);
        thedst=cvpr_compare(query,candidate,dst_method,t_allfeat);
        dst(i,dst_n:dst_n+1)=[thedst i];
    end
    dst=sortrows(dst,dst_n);  % sort the results

    %% 4) Visualise the results
    %% These may be a little hard to see using imgshow
    %% If you have access, try using imshow(outdisplay) or imagesc(outdisplay)
    if show_output == 1
        SHOW=10; % Show top 10 results
        dst_output=dst(1:SHOW,dst_n:dst_n+1);
        outdisplay=[];
        for i=1:size(dst_output,1)
           img=imread(ALLFILES{dst_output(i,2)});
           img=img(1:2:end,1:2:end,:); % make image a quarter size
           img=img(1:81,:,:); % crop image to uniform size vertically (some MSVC images are different heights)
           outdisplay=[outdisplay img];
        end

        figure()
        imshow(outdisplay);
        axis off;
    end

    %% 5) Compute Precision and Recall
    % get number of relevant images in query class
    filenames = {allfiles(:).name};
    for i=1:length(filenames)
      filename = sscanf(sprintf('%sm',filenames{i}),'%d_%d%*[m]');

      if filename(1) == qi && filename(2) > n_relevant_img(qi)
          n_relevant_img(qi) = filename(2);
      end
    end

    % check if each result img is relevant or not 
    for i=1:NIMG
        candidateimg_class = str2double(strtok(allfiles(dst(i,dst_n+1)).name, "_"));
        candidateimg(qi,i) = candidateimg_class == qi;
    end

    % calculate precision and recall of top "n" results
    for i=1:NIMG
        tp = sum(candidateimg(qi,1:i));
        p(qi,i) = tp/i;
        r(qi,i) = tp/n_relevant_img(qi);
    end

    dst_n=dst_n+2;

end

ap = sum(p.*candidateimg, 2)/mean(n_relevant_img);
map = mean(ap);

% plot ap for each class
ap(:,2) = 1:queryset_len;
ap = sortrows(ap,1,'descend');

figure()

for i=1:queryset_len
    hold on

    class_ap = [num2str(queryimg_set(1,ap(i,2))) ', AP=' num2str(round(ap(i,1)*100)) '%'];

    plot(r(ap(i,2), :), p(ap(i,2), :), 'DisplayName', class_ap, 'Color', colors(i));
end

title(['Precision-Recall curve, MAP=' num2str(round(map*100)) '%'])
xlabel('Recall')
ylabel('Precision')
legend
hold off

return;
    
    















