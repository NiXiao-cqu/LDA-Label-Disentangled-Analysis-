clear all
clc
addpath('liblinear-2.1/matlab');
addpath('libsvm-new');

% svm_C = 10;                            
option.kernel_type = 'primal';   % kernel type: primal,linear,rbf,sam.
option.sigma_x = 0.5;
option.sigma_y = 0.5;


%% Input data 
%%
%1.DEMO for testing on Office+Caltech10_surf(4DA) datasets
%% Set parameters
option.theta = 0.58;
option.beta = 1;
option.lambda = 0.25;
max_iter_num = 12;
option.dim = 89;

str_domains = { 'Caltech10', 'amazon', 'webcam', 'dslr'};
for i = 1:4
    for j = 1:4
        if i == j
            continue;
        end
        src = str_domains{i};
        tgt = str_domains{j};
        
        load(['data\' src '_SURF_L10.mat']);
        Xs = fts';
        Xs_label = labels;
        clear fts;
        clear labels;
        
        load(['data\' tgt '_SURF_L10.mat']);
        Xt = fts';
        Xt_label = labels;
        clear fts;
        clear labels;

% % 2.DEMO for testing  on Office+Caltech10_DeCAF datasets
%% Set parameters
%option.theta = 0.75;
%option.beta = 1;
%option.lambda = 0.23;
%max_iter_num = 6;
%option.dim = 192;
%  str_domains = {'amazon',  'dslr', 'webcam', 'caltech'};
%  for i = 1:4
%     for j = 1:4
%         if i == j
%             continue;
%         end
%         src = str_domains{i};
%         tgt = str_domains{j};
%         load(['data/office+caltech_10 DeCAF/' src '_decaf.mat']);
%         Xs = feas';
%         Xs_label = labels;
%         clear feas;
%         clear labels;
%         
%         load(['data/office+caltech_10 DeCAF/' tgt '_decaf.mat']);
%         Xt = feas';
%         Xt_label = labels;
%         clear feas;
%         clear labels;
%         
% %  3.DEMO for testing  on Office31_DeCAF6/7 datasets
%% Set parameters
%option.theta = 1.3;
%option.beta = 1;
%option.lambda = 0.3;
%max_iter_num = 8;
%option.dim = 195;
% str_domains = {'amazon',  'dslr', 'webcam'};
% for i = 1 : 3
%     for j = 1 : 3
%         if i == j
%             continue;
%         end
%         src = str_domains{i};
%         tgt = str_domains{j};
%         load(['data/office31 DeCAF/' src '_fc6.mat']);
%         Xs = double(fts');
%         Xs_label = labels;
%         clear fts;
%         clear labels;
%         
%         load(['data/office31 DeCAF/' tgt '_fc6.mat']);
%         Xt = double(fts');
%         Xt_label = labels;
%         clear fts;
%         clear labels;       
% % % 
% % 4.DEMO for testing  on mnist-usps_surf datasets
% str_domains = {'MNIST',  'USPS'};
% for i = 1 : 2
%     for j = 1 : 2
%         if i == j
%             continue;
%         end
%         src = str_domains{i};
%         tgt = str_domains{j};
%         load(['data/mnist+usps SURF/' src '']); 
%         Xs = X_src;
%         Xs_label = Y_src;    
%         clear X_src;
%         clear Y_src;
%         
%        load(['data/mnist+usps SURF/' tgt '']);     % target domain
%         Xt = X_src;
%         Xt_label = Y_src;    
%         clear X_src;
%         clear Y_src;

% % 5.DEMO for testing  on PIE_surf datasets
%% Set parameters
%option.theta = 2.07;
%option.beta = 1;
%option.lambda = 0.07;
%max_iter_num = 5;
%option.dim = 130;
% str_domains = {'PIE05', 'PIE07', 'PIE09', 'PIE27', 'PIE29'};
% for i = 1:5
%     for j = 1:5
%         if i == j
%             continue;
%         end
%         src = str_domains{i};
%         tgt = str_domains{j};
%         load(['data/PIE SURF/' src '']); 
%         Xs = fea';
%         Xs_label = gnd;    
%         clear fea;
%         clear gnd;
%         
%        load(['data/PIE SURF/' tgt '']);     % target domain
%         Xt = fea';
%         Xt_label = gnd;    
%         clear fea;
%         clear gnd;

% % 6.DEMO for testing  on COIL20_surf datasets
% str_domains = {'COIL_1', 'COIL_2'};
% for i = 1 : 2
%     for j = 1 : 2
%         if i == j
%             continue;
%         end
%         src = str_domains{i};
%         tgt = str_domains{j};
%         load(['data/COIL20 SURF/' src '']); 
%         Xs = X_src;
%         Xs_label = Y_src;    
%         clear X_src;
%         clear Y_src;
%         
%        load(['data/COIL20 SURF/' tgt '']);     % target domain
%         Xt = X_src;
%         Xt_label = Y_src;    
%         clear X_src;
%         clear Y_src;
%         
%% Transfer learning
%%
 ns = size(Xs,2);
 nt = size(Xt,2);
     
%1.Normalized
 Xs = Xs./repmat(sqrt(sum(Xs.^2)),[size(Xs,1) 1]); 
 Xt = Xt./repmat(sqrt(sum(Xt.^2)),[size(Xt,1) 1]); 
 X = [Xs,Xt];
[m,n] = size(X);
  
%2.transfer  and iteration
    for loop = 1 : max_iter_num
    % fake label
%         C =1; 
      C = [0.001 0.01 0.1 1.0 10 100 1000 10000];
      for chsvm = 1 :length(C)
      tmd = ['-s 3 -c ' num2str(C(chsvm)) ' -B 1 -q'];
      model(chsvm) = train(Xs_label, sparse(double(Xs')),tmd);
      [~,acc, ~] = predict(Xt_label, sparse(double(Xt')), model(chsvm), '-q');
      acc1(chsvm)=acc(1);
      end
      [acc,bestsvm_id]=max(acc1);
      model=model(bestsvm_id);
      c=C(bestsvm_id);
      
      score_Ys = model.w * [Xs; ones(1, size(Xs, 2))];
      score_Yt = model.w * [Xt; ones(1, size(Xt, 2))];
      [~, C] = max(score_Yt, [], 1);
      Xt_fake_label = C';
      for i1 = 1 : ns
      Y_s(:,i1) = softmax(score_Ys(:,i1));
      end
      for i2 = 1 : nt
      Y_t(:,i2) = softmax(score_Yt(:,i2));
      end
      Y = [Y_s,Y_t]; 
     
     % updata 
       [Z,P] = my_module(Xs,Xt,Xs_label,Xt_fake_label,Y,option);
       Xs = Z(:,1:ns);
       Xt = Z(:,(ns+1):n);     
       Xs = Xs./repmat(sqrt(sum(Xs.^2)),[size(Xs,1) 1]); 
       Xt = Xt./repmat(sqrt(sum(Xt.^2)),[size(Xt,1) 1]); 
       
      
     
       clear Y_s;
       clear Y_t;
    end
     
 
% %  classifier KNN
%   knn_model = fitcknn(Xs',Xs_label,'NumNeighbors',1);
%   cls = knn_model.predict(Xt');
%   acc_knn = sum(cls==Xt_label)/length(Xt_label)*100;

%% printf accuracy
 
     fprintf(' %s vs %s , acc=%2.2f %%\n ', src, tgt, acc);
%     fprintf(' %s vs %s , acc=%2.2f %%\n ', src, tgt, acc_knn);
  
    end
end
  
% %% 画图 迭代次数vs准确率
% %%
% if num_test == 20
% % %3DA DeCAF%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % k_st = 0:10:200;
% % figure1=figure('Color',[1 1 1]);
% % 
% % semilogy(k_st, squeeze(graph_acc(1,2,:)), 'r-o', ...
% % 	k_st,  squeeze(graph_acc(1,3,:)), 'r-v', ...
% %     k_st,  squeeze(graph_acc(2,1,:)), 'b-s', ...
% % 	k_st,  squeeze(graph_acc(2,3,:)), 'b-v', ...
% %     k_st,  squeeze(graph_acc(3,1,:)), 'g-h', ...
% % 	k_st,  squeeze(graph_acc(3,2,:)), 'g-v', ...
% % 	k_st, graph_mean_acc,'m-+','Markersize', 12,'linewidth',1);
% % % semilogy(k_st, squeeze(graph_acc(1,2,:)), 'm-+','Markersize', 12,'linewidth',1); 
% % 
% % % xlabel('k','FontSize',36);
% % ylabel('Accuracy(%)','FontSize',50);
% % xlim([0, 200]);
% % ylim([30, 100]);
% % set(gca,'fontsize',40);
% % 
% % set(gca, 'XTick',[0,20,40,60,80,100,120,140,160,180,200]);
% % set(gca, 'YTick',[30,40,50,60,70,80,90,100]);
% % set(gca, 'XTicklabel',{'0','20','40','60','80','100','120','140','160','180','200'});
% % set(gca, 'YTicklabel',{'30','40','50', '60','70','80','90', '100'});
% % 
% % legend1=legend('A-D','A-W','D-A','D-W','W-A','W-D','mean');
% % set(legend1,'FontSize',20);
% % set(legend1,'box','off');
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%MMD
% % m_st = 0:1:20;
% % figure55=figure('Color',[1 1 1]);
% % 
% % semilogy(m_st, squeeze(distance(1,2,:)), 'r-o', ...
% % 	m_st,  squeeze(distance(1,3,:)), 'r-v', ...
% %     m_st,  squeeze(distance(2,1,:)), 'b-s', ...
% % 	m_st,  squeeze(distance(2,3,:)), 'b-v', ...
% %     m_st,  squeeze(distance(3,1,:)), 'g-h', ...
% % 	m_st,  squeeze(distance(3,2,:)), 'g-v', ...
% % 	m_st, graph_mean_acc,'m-+','Markersize', 12,'linewidth',1);
% % % semilogy(k_st, squeeze(graph_acc(1,2,:)), 'm-+','Markersize', 12,'linewidth',1); 
% % 
% % % xlabel('k','FontSize',36);
% % ylabel('MMD Distance','FontSize',50);
% % xlim([0, 20]);
% % ylim([0, 2.5]);
% % set(gca,'fontsize',40);
% % 
% % set(gca, 'XTick',[0,5,10,15,20]);
% % set(gca, 'YTick',[0,0.5,1,1.5,2,2.5]);
% % set(gca, 'XTicklabel',{'0','5','10','15','20'});
% % set(gca, 'YTicklabel',{'0','0.5','1', '1.5','2','2.5'});
% % 
% % legend1=legend('A-D','A-W','D-A','D-W','W-A','W-D','mean');
% % set(legend1,'FontSize',20);
% % set(legend1,'box','off');
% 
% 
% % 
% % %4DA SURF%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % k_st = 0:1:20;
% % figure1=figure('Color',[1 1 1]);
% % 
% % semilogy(k_st, squeeze(graph_acc(1,2,:)), 'r-o', ...
% % 	k_st,  squeeze(graph_acc(1,3,:)), 'r-v', ...
% %     k_st,  squeeze(graph_acc(1,4,:)), 'r-s', ...
% % 	k_st,  squeeze(graph_acc(2,1,:)), 'b-o', ...
% %     k_st,  squeeze(graph_acc(2,3,:)), 'b-v', ...
% %     k_st,  squeeze(graph_acc(2,4,:)), 'b-s', ...
% % 	k_st,  squeeze(graph_acc(3,1,:)), 'g-o', ...
% %     k_st,  squeeze(graph_acc(3,2,:)), 'g-v', ...
% % 	k_st,  squeeze(graph_acc(3,4,:)), 'g-s', ...
% %     k_st,  squeeze(graph_acc(4,1,:)), 'y-o', ...
% %     k_st,  squeeze(graph_acc(4,2,:)), 'y-v', ...
% % 	k_st,  squeeze(graph_acc(4,3,:)), 'y-s', ...
% % 	k_st, graph_mean_acc,'m-+','Markersize', 12,'linewidth',1);
% % % semilogy(k_st, squeeze(graph_acc(1,2,:)), 'm-+','Markersize', 12,'linewidth',1); 
% % 
% % % xlabel('k','FontSize',36);
% % ylabel('Accuracy(%)','FontSize',50);
% % xlim([0, 20]);
% % ylim([30, 100]);
% % set(gca,'fontsize',40);
% % 
% % set(gca, 'XTick',[0,2,4,6,8,10,12,14,16,18,20]);
% % set(gca, 'YTick',[30,40,50,60,70,80,90,100]);
% % set(gca, 'XTicklabel',{'0','0.2','0.4','0.6','0.8','1','1.2','1.4','1.6','1.8','2'});
% % set(gca, 'YTicklabel',{'30','40','50', '60','70','80','90', '100'});
% % 
% % legend1=legend('A-D','A-W','A-C','D-A','D-W','D-C','W-A','W-D','W-C','C-A','C-D','C-W','mean');
% % set(legend1,'FontSize',20);
% % set(legend1,'box','off');
% % %%%%%%%%%%%%%%%%%%%%%%%%MMD
% % m_st = 0:1:20;
% % figure2=figure('Color',[1 1 1]);
% % 
% % semilogy(m_st, squeeze(distance(1,2,:)), 'r-o', ...
% % 	k_st,  squeeze(distance(1,3,:)), 'r-v', ...
% %     k_st,  squeeze(distance(1,4,:)), 'r-s', ...
% % 	k_st,  squeeze(distance(2,1,:)), 'b-o', ...
% %     k_st,  squeeze(distance(2,3,:)), 'b-v', ...
% %     k_st,  squeeze(distance(2,4,:)), 'b-s', ...
% % 	k_st,  squeeze(distance(3,1,:)), 'g-o', ...
% %     k_st,  squeeze(distance(3,2,:)), 'g-v', ...
% % 	k_st,  squeeze(distance(3,4,:)), 'g-s', ...
% %     k_st,  squeeze(distance(4,1,:)), 'y-o', ...
% %     k_st,  squeeze(distance(4,2,:)), 'y-v', ...
% % 	k_st,  squeeze(distance(4,3,:)), 'y-s','Markersize', 12,'linewidth',1);
% % % semilogy(k_st, squeeze(graph_acc(1,2,:)), 'm-+','Markersize', 12,'linewidth',1); 
% % 
% % % xlabel('k','FontSize',36);
% % ylabel('MMD Distance','FontSize',50);
% % xlim([0, 20]);
% % ylim([0, 0.5]);
% % set(gca,'fontsize',40);
% % 
% % set(gca, 'XTick',[0,5,10,15,20]);
% % set(gca, 'YTick',[0,0.1,0.2,0.3,0.4,0.5]);
% % set(gca, 'XTicklabel',{'0','5','10','15','20'});
% % set(gca, 'YTicklabel',{'0','0.1','0.2', '0.3','0.4','0.5'});
% % 
% % legend1=legend('A-D','A-W','A-C','D-A','D-W','D-C','W-A','W-D','W-C','C-A','C-D','C-W');
% % set(legend1,'FontSize',20);
% % set(legend1,'box','off');
% 
% % %4DA W-C SURF%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % k_st = 0:1:20;
% % figure1=figure('Color',[1 1 1]);
% % 
% % semilogy(k_st,  squeeze(graph_acc(3,4,:)), 'g-s','Markersize', 12,'linewidth',1);
% % % semilogy(k_st, squeeze(graph_acc(1,2,:)), 'm-+','Markersize', 12,'linewidth',1); 
% % 
% % % xlabel('k','FontSize',36);
% % ylabel('Accuracy(%)','FontSize',50);
% % xlim([0, 20]);
% % ylim([30, 100]);
% % set(gca,'fontsize',40);
% % 
% % set(gca, 'XTick',[0,5,10,15,20]);
% % set(gca, 'YTick',[30,40,50,60,70,80,90,100]);
% % set(gca, 'XTicklabel',{'0','5','10','15','20'});
% % set(gca, 'YTicklabel',{'30','40','50', '60','70','80','90', '100'});
% % 
% % legend1=legend('W-C');
% % set(legend1,'FontSize',20);
% % set(legend1,'box','off');
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%MMD
% % m_st = 0:1:20;
% % figure2=figure('Color',[1 1 1]);
% % 
% % semilogy(k_st,  squeeze(distance(3,4,:)), 'g-s','Markersize', 12,'linewidth',1);
% % % semilogy(k_st, squeeze(graph_acc(1,2,:)), 'm-+','Markersize', 12,'linewidth',1); 
% % 
% % % xlabel('k','FontSize',36);
% % ylabel('MMD Distance','FontSize',50);
% % xlim([0, 20]);
% % ylim([0, 0.5]);
% % set(gca,'fontsize',40);
% % 
% % set(gca, 'XTick',[0,5,10,15,20]);
% % set(gca, 'YTick',[0,0.1,0.2,0.3,0.4,0.5]);
% % set(gca, 'XTicklabel',{'0','5','10','15','20'});
% % set(gca, 'YTicklabel',{'0','0.1','0.2', '0.3','0.4','0.5'});
% % 
% % legend1=legend('W-C');
% % set(legend1,'FontSize',20);
% % set(legend1,'box','off');
% 
% %4DA W-C 维度vs SURF%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% k_st = 0:1:20;
% figure1=figure('Color',[1 1 1]);
% 
% semilogy(k_st,  squeeze(graph_acc(2,4,:)), 'g-s','Markersize', 12,'linewidth',1);
% % semilogy(k_st, squeeze(graph_acc(1,2,:)), 'm-+','Markersize', 12,'linewidth',1); 
% 
% % xlabel('k','FontSize',36);
% ylabel('Accuracy(%)','FontSize',50);
% xlim([0, 20]);
% ylim([30, 100]);
% set(gca,'fontsize',40);
% 
% set(gca, 'XTick',[0,5,10,15,20]);
% set(gca, 'YTick',[30,40,50,60,70,80,90,100]);
% set(gca, 'XTicklabel',{'0','5','10','15','20'});
% set(gca, 'YTicklabel',{'30','40','50', '60','70','80','90', '100'});
% 
% legend1=legend('D-C');
% set(legend1,'FontSize',20);
% set(legend1,'box','off');

 
% clear all
addpath('liblinear-2.1/matlab');
addpath('libsvm-new');
% end       
% clear all        