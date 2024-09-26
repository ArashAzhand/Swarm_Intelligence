% PSO for Robot Path Planning
clear all; close all; clc;
tic

% Define the grid map (0: free space, 1: obstacle)

G = [0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0; 
     0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0; 
     0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0; 
     0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0; 
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 
     0 1 1 1 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0; 
     0 1 1 1 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0;
     0 1 1 1 0 0 1 1 1 0 1 1 1 1 0 0 0 0 0 0; 
     0 1 1 1 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0; 
     0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0; 
     0 0 0 0 0 0 0 1 1 0 1 1 1 1 0 0 0 0 0 0; 
     0 0 0 0 0 0 0 1 1 0 1 1 1 1 0 0 0 0 0 0; 
     0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 1 1 1 1 0; 
     0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 1 1 1 1 0; 
     1 1 1 1 0 0 0 0 0 0 0 0 1 1 0 1 1 1 1 0; 
     1 1 1 1 0 0 1 1 0 0 0 1 0 0 0 0 0 0 0 0; 
     0 0 0 0 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0; 
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0; 
     0 0 1 1 0 0 0 0 0 0 1 1 0 0 1 0 0 0 0 0; 
     0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0];

% G=[0 0 1 1 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0; 
%    0 0 1 1 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0; 
%    0 0 1 1 0 0 1 1 0 0 0 0 0 0 0 1 1 1 1 0; 
%    0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 1 1 1 1 0; 
%    0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0; 
%    0 0 1 1 0 0 1 1 0 0 0 0 0 1 1 1 0 0 0 0; 
%    0 0 1 1 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0 0;
%    0 0 1 1 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0 0; 
%    0 0 1 1 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0; 
%    0 0 1 1 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0; 
%    0 0 0 0 0 0 0 1 1 0 0 0 1 1 0 0 0 0 0 0; 
%    0 0 0 0 0 0 0 1 1 0 0 0 1 1 0 0 0 0 0 0; 
%    0 0 1 1 0 0 0 0 0 0 0 0 1 1 0 0 1 1 1 0; 
%    0 0 1 1 0 0 0 0 0 0 0 0 1 1 0 0 1 1 1 0; 
%    0 0 1 1 0 0 0 0 0 0 0 0 1 1 0 0 1 1 1 0; 
%    0 0 1 1 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0; 
%    0 0 1 1 0 0 1 1 0 0 0 0 0 0 0 0 0 1 1 0; 
%    0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0; 
%    0 0 1 1 0 0 0 0 0 0 1 1 0 0 1 0 0 0 0 0; 
%    0 0 1 1 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0;];



[n, m] = size(G);

num_particles = 100;
max_iterations = 400;
num_stop_points = 5; % number of stop points( we modify it based on the complexity of the path)
w = 0.5; 
c1 = 1; % personal learning coefficient
c2 = 1; % global learning coefficient

% start and end points
start = [n, 1];  % bottom-left corner
goal = [1, m];   % top-right corner

particles = zeros(num_particles, num_stop_points * 2); % this is because every stop point has (x, y) and both of them should be optimised
velocities = zeros(num_particles, num_stop_points * 2);
personal_best = zeros(num_particles, num_stop_points * 2);
personal_best_fitness = inf(num_particles, 1); % this should be minimum
global_best = zeros(1, num_stop_points * 2);
global_best_fitness = inf; % this should be minimum

% initail swarm of particles
for i = 1:num_particles
    particles(i, :) = generate_random_stop_points(num_stop_points, n, m);
    personal_best(i, :) = particles(i, :); % initail the Pbest as the first position
end


% store best fitness for each iteration
best_fitness_history = zeros(1, max_iterations);



for iter = 1:max_iterations
    for i = 1:num_particles
        fitness = evaluate_fitness(particles(i, :), start, goal, G);
        
        % update personal best
        if fitness < personal_best_fitness(i)
            personal_best(i, :) = particles(i, :);
            personal_best_fitness(i) = fitness;
        end
        
        % update global best
        if fitness < global_best_fitness
            global_best = particles(i, :);
            global_best_fitness = fitness;
        end
    end
    
    best_fitness_history(iter) = global_best_fitness;
    
    % update velocities and positions
    for i = 1:num_particles
        r1 = rand(1, num_stop_points * 2);
        r2 = rand(1, num_stop_points * 2);
        
        velocities(i, :) = w * velocities(i, :) + ...
                           c1 * r1 .* (personal_best(i, :) - particles(i, :)) + ...
                           c2 * r2 .* (global_best - particles(i, :));
        
        particles(i, :) = particles(i, :) + velocities(i, :);
        
        % ensure particles stay within bounds and are integers
        for j = 1:length(particles(i,:))
            if mod(j,2) == 1  % x coordinates
                particles(i,j) = round(max(min(particles(i,j), n), 1));
            else  % y coordinates
                particles(i,j) = round(max(min(particles(i,j), m), 1));
            end
        end
    end
    
    if mod(iter, 50) == 0
        disp(['Iteration ', num2str(iter), ': Best fitness = ', num2str(global_best_fitness)]);
    end
end

% construct the best path
best_path = [start; reshape(global_best, [num_stop_points, 2]); goal];



figure(1);
plot(1:max_iterations, best_fitness_history);
title('Convergence Curve');
xlabel('Number of Iterations');
ylabel('Best Fitness');
grid on;

figure(2)
for i=1:n
    for j=1:m
        if G(i,j)==1
            x1=j-1;y1=n-i;
            x2=j;y2=n-i;
            x3=j;y3=n-i+1;
            x4=j-1;y4=n-i+1;
            fill([x1,x2,x3,x4],[y1,y2,y3,y4],'r');
            hold on
        else
            x1=j-1;y1=n-i;
            x2=j;y2=n-i;
            x3=j;y3=n-i+1;
            x4=j-1;y4=n-i+1;
            fill([x1,x2,x3,x4],[y1,y2,y3,y4],[1,1,1]);
            hold on
        end
    end
end
hold on
grid on

% Draw the path
RX = best_path(:,2) - 0.5;
RY = n - best_path(:,1) + 0.5;
plot(RX,RY,'gx-','LineWidth',1.5,'markersize',6);

% Plot start and end points
plot(0.5,0.5,'ro','MarkerSize',4,'LineWidth',4); % Starting point
plot(m-0.5,m-0.5,'gs','MarkerSize',5,'LineWidth',5); % End point

title('PSO Robot Path Planning');
xlabel('Coordinate x');
ylabel('Coordinate y');
axis([0 m 0 n]);
axis equal;

toc




function stop_points = generate_random_stop_points(num_stop_points, n, m)
    stop_points = zeros(1, num_stop_points * 2);
    for i = 1:num_stop_points
        stop_points(2*i-1) = randi([1, n]); % x
        stop_points(2*i) = randi([1, m]); % y
    end
end

function fitness = evaluate_fitness(stop_points, start, goal, G)
    path = [start; reshape(stop_points, [length(stop_points)/2, 2]); goal]; % actualy the path connects the start point and stop points and the goal point
    fitness = 0;
    [n, m] = size(G);
    
    for i = 1:size(path,1)-1 
        [x, y] = generate_path_segment(path(i,1), path(i,2), path(i+1,1), path(i+1,2)); % (x, y) two consecutive point
        fitness = fitness + length(x); % path length
        
        
        for j = 1:length(x)
            if x(j) >= 1 && x(j) <= n && y(j) >= 1 && y(j) <= m
                if G(x(j), y(j)) == 1
                    fitness = fitness + 10000; % Penalty for obstacles
                end
            else
                fitness = fitness + 10000; % increased penalty for going out of bounds
            end
        end
    end
end


% https://www.geeksforgeeks.org/bresenhams-line-generation-algorithm/
% inorder to get the points that are in the path of two points, I used
% bresenhams algorithm.
function [x, y] = generate_path_segment(x1, y1, x2, y2)
    dx = abs(x2 - x1);
    dy = abs(y2 - y1);
    steep = (dy > dx);
    if steep
        [x1, y1] = deal(y1, x1); % cross assighned
        [x2, y2] = deal(y2, x2);
    end
    if x1 > x2
        [x1, x2] = deal(x2, x1);
        [y1, y2] = deal(y2, y1);
    end
    dx = x2 - x1;
    dy = abs(y2 - y1);
    error = dx / 2;
    ystep = sign(y2 - y1);
    y = y1;
    points = [];
    for x = x1:x2
        if steep
            points = [points; y x];
        else
            points = [points; x y];
        end
        error = error - dy;
        if error < 0
            y = y + ystep;
            error = error + dx;
        end
    end
    x = points(:, 1);
    y = points(:, 2);
end
