function [ best_patch ] = quilt_top_overlap(overlap, Im, patch_size, iters)
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
  %      a = size(patch(1:overlap_size(1), :, :))
  %      b = size(overlap)
        overlap_error = single(patch(1:overlap_size(1), :, :)) - single(overlap);
        l2_error = norm(overlap_error(:));
        if l2_error < best_error
            best_error = l2_error;
            best_patch = patch;
        end
    end

    % Let's do the cut business
    e = (single(best_patch(1:overlap_size(1), :, :)) - single(overlap)).^2;
    [r, c, ~] = size(overlap);
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

    for j=1:c
        best_patch(1:pivots(j), j, :) = overlap(1:pivots(j), j, :);
    end
end
