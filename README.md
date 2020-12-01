# bitDSP-faust
*[Till Bovermann](http://tai-studio.org) & [Dario Sanfilippo](https://www.dariosanfilippo.com/) for the [rottingsounds project](http://rottingsounds.org)*


bit juggling digital signal processing for [faust](http://faust.grame.fr/).

currently implemented methods

## Overview

BitDSP is a set of FAUST library functions aimed to help explore and research artistic possibilities of bit-based algorithms. 
BitDSP offers three data formats to handle 1-bit data streams:

1. `integer`-based
2. `bitBus<N>`
3. `int32`

BitDSP currently includes implementations of bit-based functions ranging from simple bit operations over classic delta-sigma modulations to more experimental approaches like cellular automata, recursive Boolean networks, and linear feedback shift registers.


A detailed overview of the functionality is in the [paper](https://ifc20.sciencesconf.org/332745/document) "Creative use of bit-stream DSP in faust" presented at [IFC 2020](https://ifc20.sciencesconf.org/).

## Acknowledgements

This research has been funded through [RottingSounds](http://rottingsounds.org) (project AR 445-G24) by the Austrian Science Fund (FWF).
