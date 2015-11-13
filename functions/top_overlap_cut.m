function [ out_patch ] = top_overlap_cut( patch, overlap )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

    [r, c, ~] = size(overlap);
    e = (single(patch(1:r, :, :)) - single(overlap)).^2;
    E = zeros([r c]);
    pred = zeros([r c]);

    % Populate first column
    for i=1:r
        E(i, 1) = norm(reshape(e(i, 1, :), [3 1]));
        pred(i, 1) = i;
    end

    for j=2:c
        % First row
        [a, b] = min([E(1, j-1) E(2, j-1)], [], 2);
        E(1, j) = norm(reshape(e(1, j, :), [3 1])) + a;
        pred(1, j) = b;

        for i=2:r-1
            [a, b] = min([E(i-1, j-1) E(i, j-1) E(i+1, j-1)], [], 2);
            E(i, j) = norm(reshape(e(i, j, :), [3 1])) + a;
            pred(i, j) = i-2 + b;
        end

        % Last row
        [a, b] = min([E(r-1, j-1) E(r, j-1)], [], 2);
        E(r, j) = norm(reshape(e(r, j, :), [3 1])) + a;
        pred(r, j) = r-2 + b;
    end

    pivots = -100 * ones([c 1]);
    [~, pivots(c)] = min(E(:, c), [], 1);

    for i=c-1:-1:1
        pivots(i) = pred(pivots(i+1), i+1);
    end
    
    out_patch = patch;
    
    for j=1:c
        out_patch(1:pivots(j), j, :) = overlap(1:pivots(j), j, :);
    end

end

