load('data.mat');
% 'data.mat' and 'testset/%05.0f-height200.png' 
% file should be in the same file path.

%% Num 1

pw = learnPairwisePots(train);

%% Num 2

% Please uncomment  below to run num 2

n = 5;
width = 80;
height = 200;
    
% for i=1:1:n
%     % Sum Product
%     up = likelihoods(i,:); 
%     maxstates = sumproduct(pw, up);
%     tor_pos = maxstates(6,:);       % Torso Position
%     x1 = tor_pos(1) - width/2;      % Vertically Centered
%     y1 = tor_pos(2) - 1/3 * height; % 1:2 Horizontally
%     box = [x1 y1 width height];
%     drawmaxima(i, maxstates, box, GT(i, :));
%     pause(1)
% end

%% Num 3

% Please uncomment  below to run num 3

n = 5;

% for i=1:1:n
%     % Min Sum
%     up = likelihoods(i,:); 
%     maxstates = minsum(pw, up);
%     tor_pos = maxstates(6,:);       % Torso Position
%     x1 = tor_pos(1) - width/2;      % Vertically Centered
%     y1 = tor_pos(2) - 1/3 * height; % 1:2 Horizontally
%     box = [x1 y1 width height];
%     drawmaxima(i, maxstates, box, GT(i, :));
%     pause(1)
% end

%% Num 4

% Please uncomment  below to run num 4

% evaluation(pw, likelihoods, GT);