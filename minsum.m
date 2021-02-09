function [maxstates] = minsum(pairwisePots, unaryPots)
    % Min Sum - Min Log State Algorithm
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
    msg = cell(2,6);
    
    for i=1:1:5
        g = up{1, i};   % Unary Pots
        
        % Get the (g . invT)
        % The inverse of the mean shifting transformation in this case
        % is by shifting it on the opposite direction of mean
        g_invT = shiftimg(g, -pw{i, 1}, 1e-12);
        
        % Get the Log
        g_invT_log = -log(g_invT);
        
        % DT to get the value of the message
        msg{1, i} = DT(g_invT_log, pw{i, 2});   % from Li to factor to L6
    end
    
    % Torso States
    % Since it was -log, the messages are computed by addition.
    % And we can get the highest state by getting the minimum
    p_6 = msg{1,1} + msg{1,2} + msg{1,3} + msg{1,4} + msg{1,5} + -log(up{1,6});
    [row, col] = find(p_6 == min(p_6(:)));
    maxstates(6, :) = [col row];
    
    for i=1:1:5
        % Get the incoming Message
        % g_inc_msg = SUM_j(msg{j)) .* f(L6)
        g_inc_msg = p_6 - msg{1, i};       % simplified from p_6 above
        
        % Shift the messages back
        g_inc_msg_T = shiftimg(g_inc_msg, pw{i, 1}, 1e12);
        
        % DT to get the value of the message
        msg{2, i} = DT(g_inc_msg_T, pw{i, 2});  % from L6 to factor to Li
    end
    
    % Other state
    for i=1:1:5
        % Multiply but because of -log, Adding all incoming
        % msg_from_L6 + msg_from_f(Li)
        p_i = -log(up{1, i}) + msg{2, i};
        % Find the highest, but because of -log, find the minimum
        [row, col] = find(p_i == min(p_i(:)));
        maxstates(i, :) = [col row];
    end
end

