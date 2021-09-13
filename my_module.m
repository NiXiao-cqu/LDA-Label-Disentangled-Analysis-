function   [Z,P] = my_module(Xs,Xt,Xs_label,Xt_fake_label,Y,option)
%% Parameters
%%
beta = option.beta;
lambda = option.lambda;
dim = option.dim;
theta = option.theta;

kernel_type = option.kernel_type;
sigma_x = option.sigma_x;
sigma_y = option.sigma_y;
%%
X = [Xs,Xt];
ns = size(Xs,2);
nt = size(Xt,2);
[m,n] = size(X);
H = eye(n)-1/(n)*ones(n,n);

%%  Construct MMD matrix   
%%
 e = [1/ns*ones(ns,1);-1/nt*ones(nt,1)];
 C = length(unique(Xs_label));
 Mo = e * e' * C;  
 M = 0;
 C = length(unique(Xs_label));
  if ~isempty(Xt_fake_label) && length(Xt_fake_label)==nt
     for c = reshape(unique(Xs_label),1,C)
		e = zeros(n,1);
		e(Xs_label==c) = 1 / length(find(Xs_label==c));
	    e(ns+find(Xt_fake_label==c)) = -1 / length(find(Xt_fake_label==c));
		e(isinf(e)) = 0;
		M = M + e*e';
     end 
  end
    M =  Mo+M; 
	M = M / norm(M,'fro');

%% add label imformation 
%%
     X = X./repmat(sqrt(sum(X.^2)),[size(X,1) 1]);
     Z = [X;(theta*Y)]; 
     Z_m = size(Z,1);

%% Search the subspace P and updata the sample feature space
%%
    if strcmp(kernel_type,'primal')
        [P,~] = eigs(Z*M*Z'+lambda*eye(Z_m),beta*Z*H*Z',dim,'SM');
        Z =  P'*([X;Y]);
%           pT = P';
%           PX =pT( :,1:m)*X;
%           Z = [PX;Y];
    else
    	Kx = kernel_my(kernel_type,X,sigma_x);
        Ky = kernel_my(kernel_type,Y,sigma_y);
        K = [Kx;(theta*Ky)]; 
    	[P,~] = eigs(K*M*K'+lambda*eye(2*n),K*H*K',dim,'SM');
        Z =  P'*([Kx;Ky]);
	end
end

%% Convert single column labels to multi-column labels
function label=singlelbs2multilabs(y,nclass)
    L=length(y);
    label=zeros(L,nclass);
    for i=1:L
        label(i,y(i))=1;
    end
end
