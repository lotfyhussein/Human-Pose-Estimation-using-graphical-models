function [maxstates] = sumproduct(pairwisePots, unaryPots)
    % Sum Product - Max Marginal State.
    % Parameter: pairwisePots, unaryPots
    % pairwisePots can be obtained from learnPairwisePots
    % unaryPots can be obtained from likelihoods samples.
    % e.g. unaryPots = likelihoods(1,:);
    % Return: maxstates(size:6x2)
    
    pw = pairwisePots;  % for the sake of simplicity
    up = unaryPots;     % for the sake of simplicity
    
    maxstates = zeros(6, 2);
    
    % Messages
    % msg(1,:) are messages from Li to factor to L6
    % msg(2,:) are messages from L6 to factor to Li
    msg = cell(2, 6);
    
    for i=1:1:5
        g = up{1, i};   % Unary Pots
        
        % Get the (g . invT)
        % The inverse of the mean shifting transformation in this case
        % is by shifting it on the opposite direction of mean
        g_invT = shiftimg(g, -pw{i, 1}, 0);
        
        % Get Standard Deviation on both axis
        stdx = sqrt(pw{i, 2}(1, 1));
        stdy = sqrt(pw{i, 2}(2, 2));
        % Get Gaussian Kernel on both axis
        gauss_x = fspecial('gaussian', [1 3*round(stdx)], stdx);
        gauss_y = fspecial('gaussian', [3*round(stdy) 1], stdy);
        
        % Convolution on both axis
        % to get the message from Li to factor to L6
        msg{1, i} = conv2(conv2(g_invT, gauss_x, 'same'), gauss_y, 'same');
    end
    
    % Torso Marginal
    p_6 = msg{1,1} .* msg{1,2} .* msg{1,3} .* msg{1,4} .* msg{1,5} .* up{1,6};
    % Find the highest states
    [row, col] = find(p_6 == max(p_6(:)));
    maxstates(6, :) = [col row];
    
    for i=1:1:5
        % Get Standard Deviation on both axis
        stdx = sqrt(pw{i, 2}(1, 1));
        stdy = sqrt(pw{i, 2}(2, 2));
        % Get Gaussian Kernel on both axis
        gauss_x = fspecial('gaussian', [1 4*round(stdx)], stdx);
        gauss_y = fspecial('gaussian', [4*round(stdy) 1], stdy);
        
        % Get the Incoming Message
        % g_inc_msg = PROD_j(msg{j)) .* f(L6)
        g_inc_msg = p_6 ./ msg{1,i};    % simplified from p_6 above
        
        % Shift the messages back
        g_inc_msg_T = shiftimg(g_inc_msg, pw{i, 1}, 0);
        
        % Convolution on both axis
        % to get the message from L6 to factor to Li
        msg{2, i} = conv2(conv2(g_inc_msg_T, gauss_x, 'same'), gauss_y, 'same');
    end
    
    % Other Marginals
    for i=1:1:5
        % Multiply all incoming -- msg_from_L6 * msg_from_f(Li)
        p_i = up{1, i} .* msg{2, i}; 
        % Find the highest states
        [row, col] = find(p_i == max(p_i(:)));
        maxstates(i, :) = [col row];
    end
end