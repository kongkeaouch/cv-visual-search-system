function allfeatpca=computePCA(t_allfeat) 

e=Eigen_Build(t_allfeat);
e=Eigen_Deflate(e, 'keepn', 3); 
allfeatpca = Eigen_Project(t_allfeat, e)';

return;

