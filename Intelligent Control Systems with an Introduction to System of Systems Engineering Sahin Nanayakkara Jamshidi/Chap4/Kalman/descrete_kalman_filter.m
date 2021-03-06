
%Kalman filter example

%First we have to write down the system equation
%in the form x(k+1) = Phi(k)*x(k) + w(k)
%            z(k) = H(k)*x(k) + v(k)

% Phi = [1  0.01;
%        -0.02 0.07]; %State transistion matrix 
% H = [3 1]; %Measurement matrix
% R = [1];
% Q = [1];
% x = [1 0.5]';
% z = [0]';
% P_k_apriori = zeros(2);

T = 0.002; %Sampling step size
%Next we calculate some important parameters of the observer and the
%controller
[A,B,H,P_k_apriori,x_k_apriori,Q,R,feed_back] = system_para(T);
%We collect the data in the Data matrix
data = [];
%We collect the noise here to calculate the covariances. But this is a
%thearetical excercise. In practice we have to adopt another technique
v_collection = [];
w_collection = [];

for i = 1:10000
%Step1: Compute Kalman gain
K = kalman_gain(P_k_apriori,H,R);
%Step2: update estimate

w = 0.01*x_k_apriori .*randn(length(Q),1);
if i == 4000
    v = v + rand(length(v),1);
    w = w + rand(length(w),1);
end
% if i >= 1000
% v = 0.01*randn(2,1);
% w = 0.001*randn(length(Q),1);
% end
v = 0.1*H*x_k_apriori .*randn(2,1);
v_collection = [v_collection;v'];
z = H*x_k_apriori + v;
x_k_aposteriori = aposteriori_estimate(x_k_apriori,z,K,H);
%Step3: update P 
P_k_aposteriori = error_covariance(K,H,P_k_apriori);
%Step 4: Project ahead

w_collection = [w_collection;w'];
u = -feed_back*x_k_aposteriori;

if i > 4
Q = cov(w_collection);
R = cov(v_collection);
end

[x_next_apriori, P_next_apriori] = project_ahead(A,x_k_aposteriori,B,P_k_aposteriori,Q,w,u);
%Re-assign values
x_k_apriori = x_next_apriori;
P_k_apriori = P_next_apriori;

data = [data;[T*i x_k_aposteriori' z' K(1,1) K(1,2) K(2,1) K(2,2) K(3,1) K(3,2) K(4,1) K(4,2) ]];
end
% plot(data(:,1), data(:,2),data(:,1), data(:,3),data(:,1), data(:,4),data(:,1), data(:,5));
time = data(:,1);

theta_dot = data(:,2);
theta = data(:,3);
cart_vel = data(:,4);
cart_pos = data(:,5);

theta_meas = data(:,6);
cart_pos_meas = data(:,7);

K11 = data(:,8);
K12 = data(:,9);

K21 = data(:,10);
K22 = data(:,11);

K31 = data(:,12);
K32 = data(:,13);

K41 = data(:,14);
K42 = data(:,15);
figure;
plot(time,theta_dot,'k-');
legend('Observed angular velocity');
xlabel('Time [sec]');
ylabel('Ang. velocity [rad/sec]');

figure;
plot(time,theta_meas,'m-',time,theta,'k.');
legend('Measured angle','Observed angle');
xlabel('Time [sec]');
ylabel('Angle [rad]');

figure;
plot(time,cart_vel,'k-');
legend('Observed cart velocity');
xlabel('Time [sec]');
ylabel('Cart velocity [m/sec]');

figure;
plot(time,cart_pos_meas,'m-',time,cart_pos,'k.');
legend('Measured cart position','Observed cart position');
xlabel('Time [sec]');
ylabel('Cart position [m]');

figure;
subplot(4,2,1)
plot(time, K11);
legend('K11');
subplot(4,2,2)
plot(time,K12);
legend('K12');
subplot(4,2,3)
plot(time, K21);
legend('K21');
subplot(4,2,4)
plot(time,K22);
legend('K22');
subplot(4,2,5)
plot(time, K31);
legend('K31');
subplot(4,2,6)
plot(time,K32);
legend('K32');
subplot(4,2,7)
plot(time, K41);
legend('K41');
subplot(4,2,8)
plot(time,K42);
legend('K42');

xlabel('Time [sec]');
ylabel('Kalman gain');