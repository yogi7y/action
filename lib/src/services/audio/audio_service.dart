import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

/// Service responsible for handling audio playback functionality in the app.
abstract class AudioService {
  /// Plays an audio file from the given asset [path].
  ///
  /// The [path] parameter should be a valid asset path in the app's assets.
  Future<void> playAudio(String path);
}

class JustAudioService implements AudioService {
  late final _audioPlayer = AudioPlayer();

  @override
  Future<void> playAudio(String path) async {
    await _audioPlayer.setAsset(path);
    unawaited(_audioPlayer.play());
  }
}

final audioServiceProvider = Provider<AudioService>((ref) => JustAudioService());
