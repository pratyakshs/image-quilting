function [ out_im ] = synthesize( Im_inp, Im_target, alpha_list, beta, patch_size, overlap_size, factor, no )
%SYNTHESIZE
out_im = loop_over_items(Im_inp, Im_target, alpha_list(1), beta, patch_size, overlap_size, [], 0);

for i = 2:no
    patch_size = uint32(floor(double(patch_size) / factor));
    overlap_size = uint32(floor(double(overlap_size) / factor));
    out_im = loop_over_items(Im_inp, Im_target, alpha_list(i), beta, patch_size, overlap_size, out_im, 1);
end
end

