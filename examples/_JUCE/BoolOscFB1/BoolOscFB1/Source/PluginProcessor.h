/*
  ==============================================================================

    This file contains the basic framework code for a JUCE plugin processor.

  ==============================================================================
*/

#pragma once

#include <JuceHeader.h>

// FAUST specific {{{
// forward declaration of FAUST types
class dsp;
class MapUI;
#define NUMCHANNELS 2
// FAUST specific }}}

//==============================================================================
/**
*/
class BoolOScFB1AudioProcessor  : public juce::AudioProcessor {

public:
    //==============================================================================
    BoolOScFB1AudioProcessor();
    ~BoolOScFB1AudioProcessor() override;

    //==============================================================================
    void prepareToPlay (double sampleRate, int samplesPerBlock) override;
    void releaseResources() override;

   #ifndef JucePlugin_PreferredChannelConfigurations
    bool isBusesLayoutSupported (const BusesLayout& layouts) const override;
   #endif

    void processBlock (juce::AudioBuffer<float>&, juce::MidiBuffer&) override;

    //==============================================================================
    juce::AudioProcessorEditor* createEditor() override;
    bool hasEditor() const override;

    //==============================================================================
    const juce::String getName() const override;

    bool acceptsMidi() const override;
    bool producesMidi() const override;
    bool isMidiEffect() const override;
    double getTailLengthSeconds() const override;

    //==============================================================================
    int getNumPrograms() override;
    int getCurrentProgram() override;
    void setCurrentProgram (int index) override;
    const juce::String getProgramName (int index) override;
    void changeProgramName (int index, const juce::String& newName) override;

    //==============================================================================
    void getStateInformation (juce::MemoryBlock& destData) override;
    void setStateInformation (const void* data, int sizeInBytes) override;

//==============================================================================
    // set FAUST engine parameters
    void set_distort(float val);
    void set_amp(float val);
    void set_width(float val);
    void set_rot(float val);
    void set_lpfreq(float val);
    void set_coef_in(float val);
    void set_mod1(float val);
    void set_mod2(float val);
    void set_bias1(float val);
    void set_bias2(float val);

private:
    //==============================================================================
    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (BoolOScFB1AudioProcessor)

    //==============================================================================
    // FAUST specific {{{
    MapUI* fUI; // UI contains control parameters for the Faust DSP
    dsp* fDSP;  // contains audio DSP/callback
    float** outputs; // used to collect output of faust dsp
    // FAUST specific }}}
  
  // set FAUST engine parameters


};
