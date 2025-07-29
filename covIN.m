function COVARIANCE = covIN(x,y)

xbar = sum(x)/length(x);
ybar = sum(y)/length(y);

n = length(x);

covariancexy = (sum((x - xbar).*(y - ybar)))/(n-1);
covariancexx = (sum((x - xbar).*(x - xbar)))/(n-1);
covarianceyy = (sum((y - ybar).*(y - ybar)))/(n-1);

COVARIANCE = [covariancexx covariancexy ; covariancexy covarianceyy];

end