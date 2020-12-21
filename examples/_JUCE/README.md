# Compile JUCE plugins
*2020-12-21*

based on [ccrma-tutorial](https://faustdoc.grame.fr/workshops/2020-04-10-faust-juce/) on how to create a customised faust plugin 



generate dsp code

```
faust -i -a _shared/faustMinimal.h <DSP>.dsp -o <DSP>.h
```

for `BoolOscFB1`, this'd be

```
faust -i -a faustMinimal.h BoolOscFB1.dsp -o BoolOscFB1.h
```

create juce plugin with the Projucer

1. open Projucer
2. `File>New Project...`
3. select `Plugin>Basic`
4. fill in Project Name e.g. `BoolOscFB1`
5. save Project
6. move `<DSP>.h` to the source directory
7. in Projucer's File Explorer, add `<DSP>.h` to the `Source` group (`<right-click>-Add Exisiting File`)
8. In Project Settings (`View>Show Project Settings...`), select appropriate `Plugin Characteristics`, for Synths, this'd be `Plugin is a Synth` and optionally `Plugin MIDI input`
9. Open project in XCode via `Save and open in IDE`


Implement dsp parts in `PluginProcessor.h` and `PluginProcessor.cpp` (see ccrma tutorial or sources in `BoolOscFB1`).

Implement editor parts in `PluginEditor.h` and `PluginEditor.cpp` (see ccrma tutorial or sources in `BoolOscFB1`).
