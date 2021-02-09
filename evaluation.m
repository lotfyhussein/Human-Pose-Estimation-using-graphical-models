function [box] = evaluation(pairwisePots, likelihoods, GT)
    % Evaluation by comparing a bounding box
    % Input: learnPairwise, likelihoods, GT
    % pairwisePots can be obtained from learnPairwisePots
    % likelihoods can be the original likelihoods
    % GT is the ground truth data given from the assignment task
    
	n = size(likelihoods);
    % Width and Height are 
    width = 80;
    height = 200;
    
    sp_total = 0;
    ms_total = 0;
    ml_total = 0;
    
    pw = pairwisePots;      % for the sake of simplicity
    
    fprintf('Calculating');
    for i=1:1:n
        if (mod(i, 5))
            fprintf('.');
        end
        up = likelihoods(i,:);          % likelihoods
        
        % Sum Product
        maxstates = sumproduct(pw, up);
        tor_pos = maxstates(6,:);       % Torso Position
        x1 = tor_pos(1) - width/2;      % Vertically Centered
        y1 = tor_pos(2) - 1/3 * height; % 1:2 Horizontally
        box = [x1 y1 width height];
        diff = boxoverlap(box, GT(i, :));
        if (diff > 0.5)
            sp_total = sp_total + 1;
        end
        
        % Min Sum
        maxstates = minsum(pw, up);
        tor_pos = maxstates(6,:);       % Torso Position
        x1 = tor_pos(1) - width/2;      % Vertically Centered
        y1 = tor_pos(2) - 1/3 * height; % 1:2 Horizontally
        box = [x1 y1 width height];
        diff = boxoverlap(box, GT(i, :));
        if (diff > 0.5)
            ms_total = ms_total + 1;
        end
        
        % Maximum Likelihood
        torso = up{1, 6};
        [row col] = find(torso == max(torso(:)));
        tor_pos = [col row];            % Torso Position
        x1 = tor_pos(1) - width/2;      % Vertically Centered
        y1 = tor_pos(2) - 1/3 * height; % 1:2 Horizontally
        box = [x1 y1 width height];
        diff = boxoverlap(box, GT(i, :));
        if (diff > 0.5)
            ml_total = ml_total + 1;
        end
    end
    fprintf('\n');
    fprintf('Overlap::Sum Product    = %i %% \n', sp_total);
    fprintf('Overlap::Min Sum        = %i %% \n', ms_total);
    fprintf('Overlap::Max Likelihood = %i %% \n', ml_total);
end