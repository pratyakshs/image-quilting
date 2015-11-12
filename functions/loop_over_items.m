function [ out_im ] = loop_over_items( Im, norm_func, diff_func, patch_size, overlap_size, out_size )
%LOOP_OVER_ITEMS
    out_im = -1 * ones(out_size);
    for i = 1:(patch_size(1)-overlap_size(1)):out_size(1)
        for j = 1:(patch_size(2)-overlap_size(2)):out_size(2)
            patch = get_quilt_patch(out_im(i:(i + patch_size(1)), j:(j + patch_size(2))), Im, norm_func, diff_func, patch_size);
            out_im(i:(i + patch_size(1)), j:(j + patch_size(2))) = patch;
        end
    end
end

