import("stdfaust.lib");
bit = library("bitDSP.lib");
gen = library("bitDSP_gen.lib");

vol = hslider("Vol", 0, 0, 1, .000001);
stmix = si.bus(8) : par(i, 8, bit.meter(i, -60, 0)) :> si.bus(2) : par(i, 2, /(4) : bit.onebit2mbit * vol);

gates = par(i, 8, bit.autogate);
params = par(i, 2, bit.autoparam + .12345);

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
