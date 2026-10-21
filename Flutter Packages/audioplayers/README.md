```
https://pub.dev/packages/audioplayers
```

```dart
Future setAudio() async {
    // Repeat song when completed
    audioPlayer.setReleaseMode(ReleaseMode.loop);

    // Load audio from URL
    audioPlayer.setSourceUrl(widget.song.song_path);

}

Future setAudio() async {
    // Repeat song when completed
    audioPlayer.setReleaseMode(ReleaseMode.loop);

    // Load audio from File
    final file = File(...);
    audioPlayer.setSourceUrl(file.path);

}

Future setAudio() async {
    // Repeat song when completed
    audioPlayer.setReleaseMode(ReleaseMode.loop);

    // Load audio from Assets For eg: assets/audio.mp3
    audioPlayer.setSourceUrl('assets/audio.mp3');
}


Future setAudio() async {
    // Repeat song when completed
    audioPlayer.setReleaseMode(ReleaseMode.loop);

    // Load audio from Assets For eg: assets/audio.mp3
    final player = AudioCache(prefix: 'assets/');
    final url = await player.load('audio.mp3');
    audioPlayer.setSourceUrl(url);
}
```
