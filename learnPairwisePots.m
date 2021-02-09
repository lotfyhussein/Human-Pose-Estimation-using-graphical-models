function pairwisePots = learnPairwisePots(train)
    % Pairwise - Return back the maximum likelihood estimate
    % of mean and covariance
    pairwisePots = cell(6,2);
    for i=1:1:6
       % Mean and Cov based on differences
       % between body part i and j=6(torso)
       pairwisePots{i, 1} = mean(train{1, i} - train{1, 6});
       pairwisePots{i, 2} = cov(train{1, i} - train{1, 6});
    end
end