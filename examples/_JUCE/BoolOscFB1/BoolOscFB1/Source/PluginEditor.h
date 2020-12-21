/*
  ==============================================================================

    This file contains the basic framework code for a JUCE plugin editor.

  ==============================================================================
*/

#pragma once

#include <JuceHeader.h>
#include "PluginProcessor.h"

//==============================================================================
/**
*/
class BoolOScFB1AudioProcessorEditor  : public juce::AudioProcessorEditor
{
public:
    BoolOScFB1AudioProcessorEditor (BoolOScFB1AudioProcessor&);
    ~BoolOScFB1AudioProcessorEditor() override;

    //==============================================================================
    void paint (juce::Graphics&) override;
    void resized() override;

private:
    // This reference is provided as a quick way for your editor to
    // access the processor object that created it.
    BoolOScFB1AudioProcessor& audioProcessor;

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (BoolOScFB1AudioProcessorEditor)

    void makeRotary(juce::Slider &sl, juce::Label &la, std::string label, float min, float max, float init, float skew=.5f);

    // FAUST controllers

    juce::Slider SL_mod1;
    juce::Slider SL_mod2;
    juce::Slider SL_bias1;
    juce::Slider SL_bias2;

    juce::Slider SL_coef_in;

    juce::Slider SL_lpfreq;

    juce::Slider SL_distort;
    juce::Slider SL_amp;

    juce::Slider SL_rot;
    juce::Slider SL_width;


    juce::Label LA_distort;
    juce::Label LA_amp;
    juce::Label LA_width;
    juce::Label LA_rot;
    juce::Label LA_lpfreq;
    juce::Label LA_coef_in;
    juce::Label LA_mod1;
    juce::Label LA_mod2;
    juce::Label LA_bias1;
    juce::Label LA_bias2;

};
