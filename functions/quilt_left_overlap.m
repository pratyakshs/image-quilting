function [ best_patch ] = quilt_left_overlap(overlap, Im, patch_size, iters)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    best_error = inf;
    best_patch = zeros(patch_size);
    overlap_size = size(overlap);
    [r, c, ~] = size(Im);
    for i=1:iters
        r_take = randi([1, r - patch_size(1) + 1], 1, 1);
        c_take = randi([1, c - patch_size(2) + 1], 1, 1);
        patch = Im(r_take:r_take+patch_size(1)-1, c_take:c_take+patch_size(2)-1, :);
        overlap_error = single(patch(:, 1:overlap_size(2), :)) - single(overlap);
        l2_error = norm(overlap_error(:));
        if l2_error < best_error
            best_error = l2_error;
            best_patch = patch;
        end
    end
    
    % Let's do the cut business
    e = (single(best_patch(:, 1:overlap_size(2), :)) - single(overlap)).^2;
    [r, c, ~] = size(overlap);
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
    
    for i=1:r
        best_patch(i, 1:pivots(i), :) = overlap(i, 1:pivots(i), :);
    end
end
