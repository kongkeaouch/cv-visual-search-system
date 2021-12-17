function create_descriptor_globalRGBHisto(q)

%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = '/Users/kongkeaouch/Desktop/cv/MSRC_ObjCategImageDatabase_v2';

%% Folder that holds the results...
OUT_FOLDER = '/Users/kongkeaouch/Desktop/cv/descriptors';
%% and within that folder, another folder to hold the descriptors
%% we are interested in working with
OUT_SUBFOLDER='globalRGBhisto';

allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    fprintf('Processing file RGB %d/%d - %s\n',filenum,length(allfiles),fname);
    tic;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgfname_full))./256;
    fout=[OUT_FOLDER,'/',OUT_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    F=ComputeRGBHistogram(img,q);
    save(fout,'F');
    toc
end
