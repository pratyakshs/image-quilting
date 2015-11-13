function [ out_patch ] = left_overlap_cut(patch, overlap)
%UNTITLED Summary of this function goes here

    [r, c, ~] = size(overlap);
    e = (single(patch(:, 1:c, :)) - single(overlap)).^2;
    E = zeros([r c]);
    pred = zeros([r c]);
    
    % Populate first row
    for j=1:c
        E(1, j) = norm(reshape(e(1, j, :), [3 1]));
        pred(1, j) = j;
    end
    
    for i=2:r
        % first column
        [a, b] = min([E(i-1, 1) E(i-1, 2)], [], 2);
        E(i, 1) = norm(reshape(e(i, 1, :), [3 1])) + a;
        pred(i, 1) = b;
        
        for j=2:c-1
            [a, b] = min([E(i-1, j-1) E(i-1, j) E(i-1, j+1)], [], 2);
            E(i, j) = norm(reshape(e(i, j, :), [3 1])) + a;
            pred(i, j) = j-2 + b;
        end

        % last column
        [a, b] = min([E(i-1, c-1) E(i-1, c)], [], 2);
        E(i, c) = norm(reshape(e(i, c, :), [3 1])) + a;
        pred(i, c) = c-2 + b;
    end

    pivots = -100 * ones([r 1]);
    [~, pivots(r)] = min(E(r, :), [], 2);

    for i=r-1:-1:1
        pivots(i) = pred(i+1, pivots(i+1));
    end
    
    out_patch = patch;
    
    for i=1:r
        out_patch(i, 1:pivots(i), :) = overlap(i, 1:pivots(i), :);
    end

end