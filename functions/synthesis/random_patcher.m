function [ out_im ] = random_patcher( Im, patch_size, out_size, seed )
%RANDOM_PATCHER
    rng(seed,'twister');
    out_im = zeros([out_size 3]);
    [r, c, ~] = size(Im);
    for i = 1:patch_size(1):out_size(1)
        for j = 1:patch_size(2):out_size(2)
            r_i = min((i + patch_size(1) - 1), out_size(1));
            c_j = min((j + patch_size(2) - 1), out_size(2));
            r_take = randi([1, r - patch_size(1) + 1], 1, 1);
            c_take = randi([1, c - patch_size(2) + 1], 1, 1);
            r_width = r_i - i;
            c_width = c_j - j;
            out_im(i:r_i, j:c_j,:) = Im(r_take:r_take+r_width,c_take:c_take+c_width,:);
        end
    end
end

