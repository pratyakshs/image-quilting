function [ out_im ] = synthesize( Im_inp, Im_target, alpha_list, beta, patch_size, overlap_size, factor, no )
%SYNTHESIZE
out_im = loop_over_items(Im_inp, Im_target, alpha, patch_size, overlap_size, factor, [], 0);

for i = 2:no
    patch_size = double(patch_size) / factor;
    overlap_size = overlap_size / factor;
    out_im = loop_over_items(Im_inp, Im_target, alpha_list(i), beta, patch_size, overlap_size, factor, out_im, 1);
end
end

