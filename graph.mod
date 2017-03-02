model;

param V integer, >= 1;  # n_videos
param E integer, >= 1;  # n_endpoint
param R integer, >= 1;  # n_request bursts
param C integer, >= 1;  # n_caches
param X integer, >= 1;  # n_capacity

set VIDEO_SET = 1..V;   # videos set
set END_SET = 1..E;     # endpoints set
set CACHE_SET = 1..C;   # caches set
set REQUEST_SET = 1..R; # requests set

set LINK_END_VIDEO within {END_SET, VIDEO_SET}; # graph between endpoints and videos
set LINK_END_CACHE within {END_SET, CACHE_SET}; # graph between endpoints and caches

param videos{VIDEO_SET};
param end_to_DC{END_SET};
param end_to_cache{LINK_END_CACHE};
param requests{LINK_END_VIDEO};

var caches{CACHE_SET, VIDEO_SET} binary, default 0;

subject to capacity{c in CACHE_SET}: sum{v in VIDEO_SET} caches[c, v]*videos[v]<= X;

maximize max_gain: sum{(v, e, c) in {VIDEO_SET, END_SET, CACHE_SET}: (e, c) in LINK_END_CACHE and (e, v) in LINK_END_VIDEO and requests[e, v] > 0} (end_to_DC[e] - end_to_cache[e, c])*requests[e, v]*caches[c, v]
