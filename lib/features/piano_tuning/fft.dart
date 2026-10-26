// contains helper functions to calculate fft for audio sample
// this function should just 


import 'package:fftea/fftea.dart';
import 'package:wav/wav.dart';
import 'dart:typed_data';

Future<Float64x2List> calculateFFT(Float64List audio) async {

  final fft = FFT(audio.length);
  final freq = fft.realFft(audio);

  return freq;
}


void main() {
  print('testing purposes');
  const fileName = 'test.wav';
  runFFT(fileName);
}