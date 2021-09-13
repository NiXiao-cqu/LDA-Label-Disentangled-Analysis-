% %% III.MATLAB�ڴ��Ż�����
% feature memstats
% %% IV ���������
% %% 
% %1.��ʱ�����õı���
% a = rand(10000);
% b = rand(10000);
% clear a
% b = rand(10000)
% 
% %2.ʹ�ñ���ǰ��Ԥ�����ڴ�ռ�
% clear all
% clc
% n = 30000;
% tic;
% for k = 1:n
%     a(k) = 1;
% end
% time = toc;
% disp(['δԤ�����ڴ��¶�̬��ֵ��Ϊ',num2str(n),'������ʱ���ǣ�',num2str(time),'�룡'])
% 
% tic
% b = zeros(1,n);
% for k = 1:n
%     b(k) = 1;
% end
% time = toc;
% disp(['Ԥ�����ڴ��¶�̬��ֵ��Ϊ',num2str(n),'������ʱ���ǣ�',num2str(time),'�룡'])
% 
% %%
% %3.ѡ��ǡ������������
% clear all
% clc
% n = 30000;
% a = 8;
% b(1) = 8;
% c.data = 8;
% 
% tic
% for k = 1:n;
%     a;
% end
% time = toc;
% disp(['����',num2str(n),'��double�������ʱ���ǣ�',num2str(time),'�룡'])
% 
% tic
% for k = 1:n;
%     b(1);
% end
% time = toc;
% disp(['����',num2str(n),'��cell�������ʱ���ǣ�',num2str(time),'�룡'])
% 
% tic
% for k = 1:n;
%    c.data;
% end
% time = toc;
% disp(['����',num2str(n),'��struct�������ʱ���ǣ�',num2str(time),'�룡'])
% 
% %%
% %4.��������ѭ��
% clear all
% clc
% n = 1000;
% a = rand(n);
% tic
% for i = 1:n
%     for j = 1:n
%         a(i,j);  %����
%     end
% end
% toc
% 
% tic
% for i = 1:n
%     for j = 1:n
%         a(j,i); %����
%     end
% end
% toc
% 
% %%
% %5.ѭ��������ı����������ڲ�
% clear all
% clc
% tic
% a = 0;
% for i = 1:1000
%     for j = 50000
%         a = a + 1;
%     end
% end
% toc
% 
% tic
% a = 0;
% for i = 1:50000
%     for j = 1000
%         a = a + 1;
%     end
% end
% toc
% 
%  %%
%  %6.��һЩ����������
%  edit mean
%  clear all
%  clc
%  a = rand(1,10000);
%  tic
%  b = mean(a);
%  toc
%  
%  tic
%  c = sum(a)/length(a);
%  toc
%  
%  %% v.ͼ�����;��
%  %%
%  %1.�������������������?
%  x = 0:0.01:2*pi;
%  y = sin(x);
%  h = plot(x,y);
%  grid on
%  get(h)
%  set(h,'linestyle',':','linewidth',5,'color','b')
%  
% %%
% %2.����޸�����ļ���أ� get current axis��õ�ǰ��������
% set(gca,'xtick',0:0.5:7)
% set(gca,'ytick',-1:0.1:1)
% 
% %%
% %3.�������ͼ�������弰��С�أ�
% x = 0:0.01:2*pi;
% y1 = sin(x);
% y2 = cos(x);
% plot(x,y1,'r')
% hold on
% plot(x,y2,'-.b')
% h = legend('sin(x)','cos(x)');
% set(h,'fontsize',16,'color','k','edgecolor','r','textcolor','w')

% %%
% %4.��β��ͼ����?
% clear all
% clc
% x = 0:0.01:2*pi;
% y1 = sin(x);
% y2 = cos(x);
% h1 = plot(x,y1,'r');
% hold on
% h2 = plot(x,y2,'-.b');
% ax1 = axes('position',get(gca,'position'),'visible','off');
% legend(ax1,h1,'sin(x)','location','northwest')
% ax2 = axes('position',get(gca,'position'),'visible','off');
% legend(ax2,h2,'cos(x)','location','northwest')

% %% ��ͼ ģ��
% %%
% k_st = 10:3:34;
% 
% max_ces_st = [0.251014, 0.251014, 0.089194, 0.089194, ...
% 0.089194, 0.089194, 0.089194, 0.000014, 0.000014];
% 
% min_ces_st = [0.002519, 0.002519, 0.002519, 0.002519, ...
% 0.001307, 0.001307, 0.001307, 0.001307, 0.001307];
% 
% rf_ces_st = [0.002519, 0.001307, 0.001307, 0.001307, ...
% 0.001062, 0.001062, 0.001062, 0.000001, 0.000001];
% 
% area_ces_st = [0.010109, 0.010109, 0.010109, 0.010109, 0.010109, ...
% 0.008745, 0.008745, 0.006179, 0.001982];
% 
% figure1=figure('Color',[1 1 1]);
% 
% semilogy(k_st, rf_ces_st, 'r-o', ...
% 	k_st, min_ces_st, 'b-v', ...
%     k_st, max_ces_st,'g-*', ...
% 	k_st, area_ces_st,'m-+','Markersize', 24,'linewidth',2);
% 
% xlabel('k','FontSize',36);
% ylabel('RR','FontSize',36);
% xlim([10, 34]);
% ylim([1e-6, 1]);
% set(gca,'fontsize',30);
% 
% set(gca, 'XTick',[10,13,16,19,22,25,28,31,34]);
% set(gca, 'YTick',[1e-6,1e-4,1e-2,1]);
% set(gca, 'XTicklabel',{'10','13','16','19','22','25','28', '31','34'});
% set(gca, 'YTicklabel',{'0^{ }','10^{-4}','10^{-2}', '10^{0}'});
% 
% legend1=legend('RF-MinVar','MinVar','MaxDom','Area-Greedy', 'location','southwest');
% set(legend1,'FontSize',24);
% set(legend1,'box','off');

%% ��ͼ ��������vs׼ȷ��
%%
k_st = 0:1:20;

max_ces_st = [0.251014, 0.251014, 0.089194, 0.089194, ...
0.089194, 0.089194, 0.089194, 0.000014, 0.000014];

min_ces_st = [0.002519, 0.002519, 0.002519, 0.002519, ...
0.001307, 0.001307, 0.001307, 0.001307, 0.001307];

rf_ces_st = [0.002519, 0.001307, 0.001307, 0.001307, ...
0.001062, 0.001062, 0.001062, 0.000001, 0.000001];

area_ces_st = [0.010109, 0.010109, 0.010109, 0.010109, 0.010109, ...
0.008745, 0.008745, 0.006179, 0.001982];

figure1=figure('Color',[1 1 1]);

semilogy(k_st, rf_ces_st, 'r-o', ...
	k_st, min_ces_st, 'b-v', ...
    k_st, max_ces_st,'g-*', ...
	k_st, area_ces_st,'m-+','Markersize', 24,'linewidth',2);

% xlabel('k','FontSize',36);
ylabel('Mean Accuracy(%)','FontSize',36);
xlim([0, 20]);
ylim([30, 100]);
set(gca,'fontsize',30);

set(gca, 'XTick',[0,5,3,4,5,6,7,8,9]);
set(gca, 'YTick',[1e-6,1e-4,1e-2,1]);
set(gca, 'XTicklabel',{'19','34'});
set(gca, 'YTicklabel',{'0^{ }','10^{-4}','10^{-2}', '10^{0}'});

legend1=legend('RF-MinVar','MinVar','MaxDom','Area-Greedy', 'location','southwest');
set(legend1,'FontSize',24);
set(legend1,'box','off');