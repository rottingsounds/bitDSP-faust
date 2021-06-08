import("stdfaust.lib");
bitConv = library("bitDSP_conversion"); // conversion between formats library



node(function_seed, select_seed, N, K) = si.bus(N) : r_select(select_seed, K) : si.bus(K) : s_node(function_seed) with {
	s_node(seed, K) = si.bus(K) : bitConv.bitBus_to_int(K) : sc.hasher(seed + _) > 0.5 : _;
};
