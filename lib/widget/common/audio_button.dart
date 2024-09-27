import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioButton extends StatefulWidget {
  const AudioButton({super.key});

  @override
  _AudioButtonState createState() => _AudioButtonState();
}

class _AudioButtonState extends State<AudioButton> {
  final player = AudioPlayer();
  bool isPlaying = true;

  @override
  void initState() {
    super.initState();
    player.play(UrlSource(
        'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/audio_music%2Fmusic_adventure.mp3?alt=media&token=c3363f89-4c6f-42e6-aaa7-80d3c708e597'));
  }

  void _togglePlayPause() {
    if (isPlaying) {
      player.pause();
    } else {
      player.play(UrlSource(
          'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/audio_music%2Fmusic_adventure.mp3?alt=media&token=c3363f89-4c6f-42e6-aaa7-80d3c708e597'));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _togglePlayPause,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(10), // Điều chỉnh kích thước nút
      ),
      child: Icon(
        isPlaying ? Icons.music_note_sharp : Icons.music_off_sharp,
        size: 30, // Điều chỉnh kích thước biểu tượng
      ),
    );
  }
}
