model;

param V integer, >= 1;  # n_videos
param E integer, >= 1;  # n_endpoint
param R integer, >= 1;  # n_request bursts
param C integer, >= 1;  # n_caches
param X integer, >= 1;  # n_capacity
param j integer, >= 0;
param k integer, >= 0;

set VIDEO_SET = 1..V;
set END_SET = 1..E;
set CACHE_SET = 1..C;
set REQUEST_SET = 1..R;

param videos{VIDEO_SET};
param endpoints{END_SET, 1..C+1}, default 1e100;  # n_caches + 1 (DataCenter)
param requests{VIDEO_SET, END_SET}, default 0;

var caches{VIDEO_SET, CACHE_SET}, binary, default 0;

subject to cache_size{c in CACHE_SET}: sum{v in VIDEO_SET} caches[v, c]*videos[v] <= X;         # capacity constrain

maximize obj_func: sum{(v, e) in {VIDEO_SET, END_SET}} ((endpoints[e, 1] - min{c in CACHE_SET}(endpoints[e, c]*caches[v,c])) * requests[v, e]);
