import 'package:record/record.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:piano_tuner_app/features/piano_tuning/fft.dart';

class AudioStream {
  final _record = AudioRecorder();
  StreamSubscription<Uint8List>? _subscription;
  List<int> _buffer = [];

  static const int _windowSize = 16384;
  static const int _stepSize = 4096;

  Stream<List<int>> startProcessing() async* {
    if (!await _record.hasPermission()) {
      throw Exception('Microphone permission denied');
    }

    const config = RecordConfig(
      encoder: AudioEncoder.pcm16bits,
      sampleRate: 44100,
      numChannels: 1,
    );

    final rawStream = await _record.startStream(config);

    final controller = StreamController<List<int>>();

    _subscription = rawStream.listen(
      (Uint8List chunk) {
        _buffer.addAll(chunk);

        // Process data into rolling windows
        while (_buffer.length >= _windowSize) {
          final window = _buffer.sublist(0, _windowSize);
          controller.add(window);

          // Slide forward by 25%
          _buffer = _buffer.sublist(_stepSize);
        }
      },
      onError: (error) => controller.addError(error),
      onDone: () => controller.close(),
    );

    yield* controller.stream;
  }

  Future<void> stopProcessing() async {
    await _subscription?.cancel();
    _subscription = null;
    await _record.stop();
    await _record.dispose();
    _buffer.clear();
  }
}