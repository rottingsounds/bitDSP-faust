DSM2 : UGen
{
	*ar { | in1, polarity = \unipolar |
		(polarity == \unipolar).if({
			^DSM2unipolar.ar(in1);
		}, {
			^DSM2bipolar.ar(in1);
		})
	}

	*kr { | in1, polarity = \unipolar |
		(polarity == \unipolar).if({
			^DSM2unipolar.kr(in1);
		}, {
			^DSM2bipolar.kr(in1);
		})
	}
}

