clear all; close all; clc;
load('Sharad.mat')

% Initial guesses 
Ai = 1e-25;
ni = 1.1;
p0 = [Ai ni];

% Optimization options
options = optimoptions(@fminunc, 'Algorithm', 'quasi-newton');

% Objective function
H_cost = @(n) norm((-a.*(n+2)./(2*Ai).*(rho*g).^(-n).*abs(dhdx).^(1-n)./dhdx).^(1/(n+2)) - H_obs)^2;

% Minimize H_cost to find n
[n,Hval,exitflag1,output1] = fminunc(H_cost,ni,options);

% Minimize H_cost2 to find A
H_cost2 = @(A) norm((-a.*(n+2)./(2*A).*(rho*g).^(-n).*abs(dhdx).^(1-n)./dhdx).^(1/(n+2)) - H_obs)^2;
[A,Aval,exitflag2,output2] = fminunc(H_cost2,Ai,options);

% Miniminze H_cost3 to find both A and n simultaniously
H_cost3 = @(p) norm((-a.*(p(2)+2)./(2*p(1)).*(rho*g).^(-p(2)).*abs(dhdx).^(1-p(2))./dhdx).^(1/(p(2)+2)) - H_obs)^2;
[p,f3val,exitflag3,output3] = fminunc(H_cost3,p0,options);


%% Linearized H_cost
% Miniminze H_cost3 to find both A and n simultaniously
A1 = -25;
n1 = 1.1;
p0 = [A1, n1];

H_costl3 = @(p) norm((-a.*(p(2)+2)./(2*10^p(1)).*(rho*g).^(-p(2)).*abs(dhdx).^(1-p(2))./dhdx).^(1/(p(2)+2)) - H_obs)^2;
[pl3,fval,exitflag3,output3] = fminunc(H_costl3,p0,options);


%% Linearized Least squares
A2 = -25;
n2 = 1.1;
p0 = [A2, n2];

H_vec = @(p)(-a.*(p(2)+2)./(2*10^p(1)).*(rho*g).^(-p(2)).*abs(dhdx).^(1-p(2))./dhdx).^(1/(p(2)+2)) - H_obs;
plLS = lsqnonlin(H_vec, p0)



%% Surfplot
% A_plot = linspace(1.089e-25,1.1e-25);
% n_plot = linspace(2.2,2.6);

A_plot = logspace(-23,-30, 256);
n_plot = linspace(2,3.4, 256);

for i = 1:length(n_plot)
    for j = 1:length(A_plot)
        H_plot(i,j) = H_cost3([A_plot(i) n_plot(j)]);
    end
%     H_plot(i) = H_cost2(A_plot(i));
end


% plot(1:100, H_plot)
figure(1)
surf(n_plot,log10(A_plot),log10(H_plot),'EdgeColor','none')
hold on
H_minLS = H_cost3([10^plLS(1), plLS(2)]);
plot3(plLS(2),plLS(1),log10(H_minLS),'marker','o')

H_minl3 = H_cost3([10^pl3(1), pl3(2)]);
plot3(pl3(2),pl3(1),log10(H_minl3),'marker','o')

plot3(p(2), log10(p(1)), log10(f3val), 'marker', 'o')
plot3(ni, log10(A), log10(Aval), 'marker', 'o')
plot3(n, log10(Ai), log10(Hval), 'marker', 'o')
hold off

xlabel('n');
ylabel('log10(A)');






