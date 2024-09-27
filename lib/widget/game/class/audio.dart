import 'package:audioplayers/audioplayers.dart';

class Audio {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _backgroundMusic = AudioPlayer();

  void playSuccessSound() async {
    try {
      _audioPlayer.play(UrlSource(
          'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/audio_music%2Fsuccess.mp3?alt=media&token=919d8f19-6b63-4c13-8669-7acab46d3132'));
    } catch (e, stacktrace) {
      print('Error playing success sound: $e');
      print(stacktrace);
    }
  }

  void playWrongSound() async {
    try {
      _audioPlayer.play(UrlSource(
          'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/audio_music%2Fwrong.mp3?alt=media&token=a0fb0ae0-a8df-4909-8f53-b884ab05d9ef'));
    } catch (e, stacktrace) {
      print('Error playing wrong sound: $e');
      print(stacktrace);
    }
  }

  void playCompleteSound() async {
    try {
      _audioPlayer.play(UrlSource(
          'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/audio_music%2Fcompleted.mp3?alt=media&token=12348381-4975-4530-b435-0612f5a7d4fd'));
    } catch (e, stacktrace) {
      print('Error playing complete sound: $e');
      print(stacktrace);
    }
  }

  void playMouseClickSound() async {
    try {
      _audioPlayer.play(UrlSource(
          'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/audio_music%2Fmouse-click.mp3?alt=media&token=99317ee8-ed5e-4bc2-ad00-2c149123072e'));
    } catch (e, stacktrace) {
      print('Error playing click sound: $e');
      print(stacktrace);
    }
  }

  void playDropSound() async {
    try {
      _audioPlayer.play(UrlSource(
          'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/audio_music%2Fdrop.mp3?alt=media&token=e974eff8-5085-46b8-a4fd-f3a508883e54'));
    } catch (e, stacktrace) {
      print('Error playing drop sound: $e');
      print(stacktrace);
    }
  }

  void playButtonSound() async {
    try {
      _audioPlayer.play(UrlSource(
          'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/audio_music%2Fbutton.mp3?alt=media&token=65f98983-3aea-4b26-8c57-44a6bc22db46'));
    } catch (e, stacktrace) {
      print('Error playing button sound: $e');
      print(stacktrace);
    }
  }

  void playBackgroundMusicHappyFarm() async {
    try {
      await Future.delayed(const Duration(seconds: 3));
      _backgroundMusic.play(UrlSource(
          'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/audio_music%2Fmusic_adventure.mp3?alt=media&token=c3363f89-4c6f-42e6-aaa7-80d3c708e597'));
    } catch (e, stacktrace) {
      print('Error playing background music: $e');
      print(stacktrace);
    }
  }

  void playBackgroundMusicAdventure() async {
    try {
      await Future.delayed(const Duration(seconds: 3));
      _backgroundMusic.play(UrlSource(
          'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/audio_music%2Fmusic_adventure.mp3?alt=media&token=c3363f89-4c6f-42e6-aaa7-80d3c708e597'));
    } catch (e, stacktrace) {
      print('Error playing background music: $e');
      print(stacktrace);
    }
  }

  void stopBackgroundMusic() {
    _backgroundMusic.stop();
  }
}
