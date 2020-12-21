/*
  ==============================================================================

    This file contains the basic framework code for a JUCE plugin editor.

  ==============================================================================
*/

#include "PluginProcessor.h"
#include "PluginEditor.h"

//==============================================================================
BoolOScFB1AudioProcessorEditor::BoolOScFB1AudioProcessorEditor (BoolOScFB1AudioProcessor& p)
: AudioProcessorEditor (&p), audioProcessor (p) {
  // Make sure that before the constructor has finished, you've set the
  // editor's size to whatever you need it to be.
  setSize (800, 720);
  setResizable (true, true);

  makeRotary(SL_distort, LA_distort, "distort", 1.0f, 100.0f, 1.0f, 2.f);
  SL_distort.onValueChange = [this] {
      audioProcessor.set_distort(SL_distort.getValue());
  };

  makeRotary(SL_amp, LA_amp, "amp", .0f, 1.0f, 1.0f, .5f);
  SL_amp.onValueChange = [this] {
      audioProcessor.set_amp(SL_amp.getValue());
  };

  makeRotary(SL_width, LA_width, "width", .0f, 1.0f, 1.0f, .5f);
  SL_width.onValueChange = [this] {
      audioProcessor.set_width(SL_width.getValue());
  };

  makeRotary(SL_rot, LA_rot, "rot", .0f, 1.0f, 1.0f, .5f);
  SL_rot.onValueChange = [this] {
      audioProcessor.set_rot(SL_rot.getValue());
  };
  
  makeRotary(SL_lpfreq, LA_lpfreq, "lpfreq", 10.0f, 20000.0f, 1000.0f, 8000.f); // skew: TODO
  SL_lpfreq.onValueChange = [this] {
      audioProcessor.set_lpfreq(SL_lpfreq.getValue());
  };

  makeRotary(SL_coef_in, LA_coef_in, "coef_in", .0f, 1.0f, .0f, .5f); // skew: TODO
  SL_coef_in.onValueChange = [this] {
      audioProcessor.set_coef_in(SL_coef_in.getValue());
  };

  makeRotary(SL_coef_in, LA_coef_in, "coef_in", .0f, 1.0f, .0f, .5f); // skew: TODO
  SL_coef_in.onValueChange = [this] {
      audioProcessor.set_coef_in(SL_coef_in.getValue());
  };


  makeRotary(SL_mod1, LA_mod1, "mod1", .0f, 1.0f, .0f, .5f); // skew: TODO
  SL_mod1.onValueChange = [this] {
      audioProcessor.set_mod1(SL_mod1.getValue());
  };

  makeRotary(SL_mod2, LA_mod2, "mod2", .0f, 1.0f, .0f, .5f); // skew: TODO
  SL_mod2.onValueChange = [this] {
      audioProcessor.set_mod2(SL_mod2.getValue());
  };

  makeRotary(SL_bias1, LA_bias1, "bias1", .0f, 1.0f, .0f, .5f); // skew: TODO
  SL_bias1.onValueChange = [this] {
      audioProcessor.set_bias1(SL_bias1.getValue());
  };

  makeRotary(SL_bias2, LA_bias2, "bias2", .0f, 1.0f, .0f, .5f); // skew: TODO
  SL_bias2.onValueChange = [this] {
      audioProcessor.set_bias2(SL_bias2.getValue());
  };
}


void BoolOScFB1AudioProcessorEditor::makeRotary(juce::Slider& sl, juce::Label& la, std::string label, float min, float max, float init, float skew) {
  addAndMakeVisible(sl);
  sl.setSliderStyle(juce::Slider::SliderStyle::Rotary);
  sl.setRange(min, max);
  sl.setSkewFactorFromMidPoint(skew);
  sl.setValue(init);
  
  addAndMakeVisible(la);
  la.setText(label, juce::dontSendNotification);
  la.attachToComponent(&sl, true);
  sl.setTextBoxStyle(juce::Slider::TextBoxBelow, true, 100, 25);
}

BoolOScFB1AudioProcessorEditor::~BoolOScFB1AudioProcessorEditor() {
}

//==============================================================================
void BoolOScFB1AudioProcessorEditor::paint (juce::Graphics& g) {
    // (Our component is opaque, so we must completely fill the background with a solid colour)
    g.fillAll (getLookAndFeel().findColour (juce::ResizableWindow::backgroundColourId));
}


void BoolOScFB1AudioProcessorEditor::resized() {
    // This is generally where you'll want to lay out the positions of any
    // subcomponents in your editor..

  const int border = 40;
  const int rotWidth = 160;
  const int rotHeight = 80;
  const int elemOffsetX = 20 + rotWidth;
  const int elemOffsetY = 20 + rotHeight;
  
//    const int sliderLeft = 80;

  SL_bias1.setBounds(border + (0 * elemOffsetX), border + (0 * elemOffsetY), rotWidth, rotHeight);
  SL_mod1 .setBounds(border + (2 * elemOffsetX), border + (0 * elemOffsetY), rotWidth, rotHeight);


  SL_bias2.setBounds(border + (0 * elemOffsetX), border + (2 * elemOffsetY), rotWidth, rotHeight);
  SL_mod2 .setBounds(border + (2 * elemOffsetX), border + (2 * elemOffsetY), rotWidth, rotHeight);

  SL_coef_in.setBounds(border + (1 * elemOffsetX), border + (1 * elemOffsetY), rotWidth, rotHeight);

  SL_lpfreq.setBounds(border + (1 * elemOffsetX), border + (3 * elemOffsetY), rotWidth, rotHeight);

  SL_distort.setBounds(border + (0 * elemOffsetX), border + (4 * elemOffsetY), rotWidth, rotHeight);
  SL_amp.setBounds(border + (2 * elemOffsetX), border + (4 * elemOffsetY), rotWidth, rotHeight);

  SL_rot.setBounds(border + (0 * elemOffsetX), border + (5 * elemOffsetY), rotWidth, rotHeight);
  SL_width.setBounds(border + (2 * elemOffsetX), border + (5 * elemOffsetY), rotWidth, rotHeight);


}




















