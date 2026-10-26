import 'package:test/test.dart';
import 'package:piano_tuner_app/features/piano_tuning/fft.dart';

void main() {
  group('FFT Unit tests', () {
    test('runFFT should return a frequency', () {
      const input = 'test.wav';

      final result = runFFT(input);

      expect(result, 'idk');
    });
  });
}