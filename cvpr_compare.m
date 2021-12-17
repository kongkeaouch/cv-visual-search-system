function dst=cvpr_compare(query,candidate,dst_method,t_allfeat)
% This function should compute the distance
% between the two descriptors

x=query-candidate;

if dst_method == "Euclidean"
    x=x.^2;
    x=sum(x);
    dst=sqrt(x);
end

if dst_method == "Manhattan"
    x=abs(x);
    dst=sum(x);
end

if dst_method == "Mahalanobis"
    e=Eigen_Build(t_allfeat);
    v=e.val;
    x=x.^2./v(1:size(candidate,2), 1)';
    x=sum(x);
    dst=sqrt(x);
end

return;
