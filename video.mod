model;

param V integer, >= 1;  # n_videos
param E integer, >= 1;  # n_endpoint
param R integer, >= 1;  # n_request bursts
param C integer, >= 1;  # n_caches
param X integer, >= 1;  # n_capacity

set VIDEO_SET = 1..V;
set END_SET = 1..E;
set CACHE_SET = 1..C;
set REQUEST_SET = 1..R;

param videos{VIDEO_SET} integer, >= 0;
param end_to_cache{END_SET, CACHE_SET} integer, >= 0, default 1e100;    # latency from endpoint "e" to cache "c"
param end_to_DC{END_SET} integer, >= 0, default 1e100;                  # latency from endpoint "e" to DC (datacenter)
param requests{END_SET, VIDEO_SET} integer, >= 0, default 0;            # number of request from endpoint "e" to video "v"

var caches{CACHE_SET, VIDEO_SET}, binary, default 0;                    # binary (1 = video "v" is in cache "c"; 0 = video "v" is NOT in cashe "v")

subject to cache_size{c in CACHE_SET}: sum{v in VIDEO_SET} caches[c, v]*videos[v] <= X;         # capacity constrain

maximize obj_func: sum{v in VIDEO_SET} max{(e, c) in {END_SET, CACHE_SET}}(end_to_DC[e] - end_to_cache[e, c])*requests[e, v]*caches[c, v];
