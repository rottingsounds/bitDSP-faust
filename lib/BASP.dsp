import("stdfaust.lib");
bit = library("bitDSP.lib");
gen = library("bitDSP_gen.lib");

vol = hslider("[05]Vol", 0, 0, 1, .000001);
stmix = si.bus(8) : par(i, 8, bit.meter(i, -60, 0)) :> si.bus(2) : par(i, 2, /(4) : bit.onebit2mbit * vol);

gates = par(i, 8, bit.autogate(gate_rate));
params = par(i, 2, bit.autoparam(sah_rate, diff_rate, alpha, beta) + init);

init = .1890809373898301;

gate_rate = 1000 ^ hslider("[00]Gate de/activation rate (.001-1000 Hz)", 0, -1, 1, .000001);
sah_rate = 1000 ^ hslider("[01]Stepped changes rate (.001-1000 Hz)", 0, -1, 1, .000001);
diff_rate = 1000 ^ hslider("[02]Parameter glissandi rate (.001-1000 Hz)", 0, -1, 1, .000001);

alpha = hslider("[03]Off relay threshold", .5, 0, 1, .000001);
beta = hslider("[04]On relay threshold", .8, 0, 1, .000001);

circular = route(8, 8, (1,3), (2,4), (3,5), (4,6), (5,7), (6,8), (7,1), (8,2));

agent1 = params : gen.gen1;
agent2 = params : gen.gen2;
agent3 = params : gen.gen3;
agent4 = params : gen.gen4;

network =   (   agent1 , 
                agent2 , 
                agent3 , 
                agent4) ~
            circular : gates : stmix;

process = network;
