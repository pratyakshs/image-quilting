function [ out_im ] = loop_over_items( Im, patch_size, overlap_size, out_size )
%LOOP_OVER_ITEMS
    out_im = -1 * ones([out_size 3]);
    for i = 1:(patch_size(1)-overlap_size(1)):out_size(1)
        for j = 1:(patch_size(2)-overlap_size(2)):out_size(2)
            r_i = min((i + patch_size(1) - 1), out_size(1));
            c_j = min((j + patch_size(2) - 1), out_size(2));
            my_patch_size = size(out_im(i:r_i, j:c_j, :));
            patch = get_quilt_patch(out_im(i:r_i, j:c_j, :), Im, my_patch_size, overlap_size, i, j);
            out_im(i:r_i, j:c_j, :) = patch;
        end
    end
end
