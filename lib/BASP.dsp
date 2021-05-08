/*******************************************************************************
*   BASP is a project for the creative use of bitstream musical DSP in Faust.
*   The work relies on a several library modules developed over almost a year
*   by Dario Sanfilippo and Till Bovermann. The library includes standard 
*   functions for delta-sigma modulation and processing as well as original
*   algorithms for information processing and audio manipulation.
*   Part of the library modules are described in the following publication:
*   https://ifc20.sciencesconf.org/332745/document.
*
*   The code below was developed by Dario Sanfilippo and it is a music
*   piece based on an adaptive, self-organising bitstream network. The work
*   includes four interdependent adaptive agents deploying different
*   techniques for the analysis, adaptation, and manipulation of single-bit
*   audio streams. 
*
*   Specifically, the adaptation infrastructure includes
*   statistical samplewise processing for the measurement of polarity
*   tendency, and an experimental algorithm for the approximation of
*   noisiness through fixed-latency autocorrelation. The adaptation mechanisms
*   operate both at timbral and formal time-scales for short and long-term
*   evolutions, and deploy hysteresis for low and high-level activation
*   functions for enhanced complexity.
*
*   The algorithms for audio generation and manupilation include chaotic
*   self-oscillating systems based on bitwise operations, cross-coupled
*   delta-sigma filters, and nonlinear distortion through bitstream
*   audio pattern-matching.
*
*   Even though the system has been designed to operate autonomously, the
*   user interface provides parameters to alter the adaptation infrustructure
*   to experience the work through different self-organising dynamics.
*
*   PARAMETERS:
*
*       - Gate de/activation rate (.001-.125 Hz): this parameter affects
*       affects the responsiveness of the statistical analysis that opens
*       and closes the outputs of the individual agents. The collective
*       behaviour of this gating de/activation results in an autonomous
*       regulation of the agents' presence over time.
*
*       - Stepped changes rate (.001-.125 Hz): this parameter affects the
*       responsiveness of the adaptation mechanism dedicated to stepped
*       self-modulation. The input of each agent is analysed and the condition
*       to trigger a new parameter is given by a change of direction of the
*       signal, whereas the target value is determined by a time-variant
*       function that is given by integration of the magnitude of the 
*       derivative.
*
*       - Continuous changes rate (.001-.125 Hz): this parameter sets the
*       cut-off of a set of cascaded one-pole lowpass filters that act upon
*       the input signal of each agent. Slow cut-off values result in slower
*       continuous variations of the parameters, as the derivartive of the
*       input is decreased.
*
*       - On/Off relay threshold: - these parameters set the lower and upper
*       boundaries of a one-bit hysteresis function, that is the deactivation
*       and activation thresholds, respectively. This hysteresis function
*       controls the parameter self-modulation modality: stepped, or continuous.
*
*******************************************************************************/

import("stdfaust.lib");

declare name "BASP – Boolean Audio Signal Processing";
declare author "Dario Sanfilippo";
declare copyright "Copyright (C) 2021 Dario Sanfilippo
    <sanfilippo.dario@gmail.com>";
declare version "1.0";
declare license "MIT license";

bit = library("bitDSP.lib");
gen = library("bitDSP_gen.lib");

vol = hslider("[05]Vol", 0, 0, 1, .000001);
stmix = si.bus(8) : par(i, 8, bit.meter(i, -60, 0)) :> si.bus(2) : par(i, 2, /(4) : bit.onebit2mbit * vol);

gates = par(i, 8, bit.autogate(gate_rate));
params = par(i, 2, bit.autoparam(step_rate, incr_rate, alpha, beta) + init);

init = .1890809373898301;

gate_rate = hslider("[00]Gate de/activation rate (.001-.125 Hz)", .01, .001, .125, .000001);
step_rate = hslider("[01]Stepped changes rate (.001-.125 Hz)", .01, .001, .125, .000001);
incr_rate = hslider("[02]Continuous changes rate (.001-.125 Hz)", .01, .001, .125, .000001);

alpha = hslider("[03]Off relay threshold", .3, 0, 1, .000001);
beta = hslider("[04]On relay threshold", .7, 0, 1, .000001);

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
