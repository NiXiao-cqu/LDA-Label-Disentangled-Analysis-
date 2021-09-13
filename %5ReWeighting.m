function Xs_new = ReWeighting(Xs,Xt)
%%
ns = size(Xs,2);
nt = size(Xt,2);
n = ns + nt;
D = zeros(nt,ns);
W = zeros(ns,1);
%% initial W
% for i = 1:ns      
%     W(i) = length(find(Xs_label==Xs_label(i)))/ns;
% end
% 
for j = 1:nt
    for i = 1:ns
       D(j,i) = (Xt(:,j)-Xs(:,i))'*(Xt(:,j)-Xs(:,i));
    end
end
% 
 D_min = min(D,[],2);
%
for i = 1:ns
    for j = 1:nt
        if (D(j,i)==D_min(j) ) 
            W(i) = W(i) + 1 ;
        else 
            W(i) = W(i);
        end
    end
end

Xs_new = Xs*diag(W');