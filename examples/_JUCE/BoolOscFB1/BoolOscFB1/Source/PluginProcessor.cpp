/*
  ==============================================================================

    This file contains the basic framework code for a JUCE plugin processor.

  ==============================================================================
*/

#include "PluginProcessor.h"
#include "PluginEditor.h"

// FAUST specific {{{
#include "BoolOscFB1.h"
// FAUST specific }}}


//==============================================================================
BoolOScFB1AudioProcessor::BoolOScFB1AudioProcessor()
#ifndef JucePlugin_PreferredChannelConfigurations
: AudioProcessor (BusesProperties()
                     #if ! JucePlugin_IsMidiEffect
                      #if ! JucePlugin_IsSynth
 .withInput  ("Input",  juce::AudioChannelSet::stereo(), true)
                      #endif
 .withOutput ("Output", juce::AudioChannelSet::stereo(), true)
                     #endif
 )
#endif
{
}

BoolOScFB1AudioProcessor::~BoolOScFB1AudioProcessor() {}

//==============================================================================
const juce::String BoolOScFB1AudioProcessor::getName() const {
  return JucePlugin_Name;
}

bool BoolOScFB1AudioProcessor::acceptsMidi() const {
   #if JucePlugin_WantsMidiInput
  return true;
   #else
  return false;
   #endif
}

bool BoolOScFB1AudioProcessor::producesMidi() const {
   #if JucePlugin_ProducesMidiOutput
  return true;
   #else
  return false;
   #endif
}

bool BoolOScFB1AudioProcessor::isMidiEffect() const {
   #if JucePlugin_IsMidiEffect
  return true;
   #else
  return false;
   #endif
}

double BoolOScFB1AudioProcessor::getTailLengthSeconds() const {
  return 0.0;
}

int BoolOScFB1AudioProcessor::getNumPrograms() {
    return 1;   // NB: some hosts don't cope very well if you tell them there are 0 programs,
                // so this should be at least 1, even if you're not really implementing programs.
}

int BoolOScFB1AudioProcessor::getCurrentProgram() {
  return 0;
}

void BoolOScFB1AudioProcessor::setCurrentProgram (int index) {
}

const juce::String BoolOScFB1AudioProcessor::getProgramName (int index) {
  return {};
}

void BoolOScFB1AudioProcessor::changeProgramName (int index, const juce::String& newName) {
}

//==============================================================================
void BoolOScFB1AudioProcessor::prepareToPlay (double sampleRate, int samplesPerBlock) {

  // FAUST specific {{{
  fDSP = new mydsp();     // Faust DSP object
  fDSP->init(sampleRate); // set samplerate

  // FAUST UI mapper
  fUI = new MapUI();
  fDSP->buildUserInterface(fUI);

  // initialise outputs
  outputs = new float*[NUMCHANNELS];
  for (int channel = 0; channel < NUMCHANNELS; ++channel) {
    outputs[channel] = new float[samplesPerBlock];
  }
  // FAUST specific }}}
}

void BoolOScFB1AudioProcessor::releaseResources() {
    // FAUST specific stuff {{{
    delete fDSP;
    delete fUI;
    for (int channel = 0; channel < NUMCHANNELS; ++channel) {
      delete[] outputs[channel];
    }
    delete [] outputs;
    // FAUST specific stuff }}}
}

#ifndef JucePlugin_PreferredChannelConfigurations
bool BoolOScFB1AudioProcessor::isBusesLayoutSupported (const BusesLayout& layouts) const {
  #if JucePlugin_IsMidiEffect
  juce::ignoreUnused (layouts);
  return true;
  #else
    // This is the place where you check if the layout is supported.
    // In this template code we only support mono or stereo.
  if (layouts.getMainOutputChannelSet() != juce::AudioChannelSet::mono()
   && layouts.getMainOutputChannelSet() != juce::AudioChannelSet::stereo())
    return false;

    // This checks if the input layout matches the output layout
   #if ! JucePlugin_IsSynth
  if (layouts.getMainOutputChannelSet() != layouts.getMainInputChannelSet())
    return false;
   #endif

  return true;
  #endif
}
#endif

void BoolOScFB1AudioProcessor::processBlock (juce::AudioBuffer<float>& buffer, juce::MidiBuffer& midiMessages) {

  juce::ScopedNoDenormals noDenormals;
  // auto totalNumInputChannels = getTotalNumInputChannels();
  auto totalNumOutputChannels = getTotalNumOutputChannels();
  
       // for (auto i = totalNumInputChannels; i < totalNumOutputChannels; ++i)
       //     buffer.clear (i, 0, buffer.getNumSamples());
  
  fDSP->compute(buffer.getNumSamples(),NULL,outputs);
  for (int channel = 0; channel < totalNumOutputChannels; ++channel) {
    for (int i = 0; i < buffer.getNumSamples(); i++) {
      *buffer.getWritePointer(channel,i) = outputs[channel][i];
    }
  }
}

//==============================================================================
bool BoolOScFB1AudioProcessor::hasEditor() const {
  return true; // (change this to false if you choose to not supply an editor)
}

juce::AudioProcessorEditor* BoolOScFB1AudioProcessor::createEditor() {
  return new BoolOScFB1AudioProcessorEditor (*this);
}

//==============================================================================
void BoolOScFB1AudioProcessor::getStateInformation (juce::MemoryBlock& destData) {
  // You should use this method to store your parameters in the memory block.
  // You could do that either as raw data, or use the XML or ValueTree classes
  // as intermediaries to make it easy to save and load complex data.
}
void BoolOScFB1AudioProcessor::setStateInformation (const void* data, int sizeInBytes) {
  // You should use this method to restore your parameters from this memory block,
  // whose contents will have been created by the getStateInformation() call.
}

//===============================================================================
// FAUST parameter setter
void BoolOScFB1AudioProcessor::set_distort(float val) {
  fUI->setParamValue("m_distort", val);
};
void BoolOScFB1AudioProcessor::set_amp(float val) {
  fUI->setParamValue("m_amp", val);
};
void BoolOScFB1AudioProcessor::set_width(float val) {
  fUI->setParamValue("m_width", val);
};
void BoolOScFB1AudioProcessor::set_rot(float val) {
  fUI->setParamValue("m_rot", val);
};
void BoolOScFB1AudioProcessor::set_lpfreq(float val) {
  fUI->setParamValue("m_lpfreq", val);
};
void BoolOScFB1AudioProcessor::set_coef_in(float val) {
  fUI->setParamValue("d_leak", val);
};
void BoolOScFB1AudioProcessor::set_mod1(float val) {
  fUI->setParamValue("d_mod1", val);
};
void BoolOScFB1AudioProcessor::set_mod2(float val) {
  fUI->setParamValue("d_mod2", val);
};
void BoolOScFB1AudioProcessor::set_bias1(float val) {
  fUI->setParamValue("d_bias1", val);
};
void BoolOScFB1AudioProcessor::set_bias2(float val) {
  fUI->setParamValue("d_bias2", val);
};

//==============================================================================
// This creates new instances of the plugin..
juce::AudioProcessor* JUCE_CALLTYPE createPluginFilter() {
  return new BoolOScFB1AudioProcessor();
}
