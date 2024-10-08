//Eunseong Han
//Nyima Gaye

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:math';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spooky Characters',
      theme:
          ThemeData(scaffoldBackgroundColor: Colors.orange, useMaterial3: true),
      home: const SpookyHomePage(),
    );
  }
}

class SpookyHomePage extends StatefulWidget {
  const SpookyHomePage({super.key});

  @override
  _SpookyHomePageState createState() => _SpookyHomePageState();
}

class _SpookyHomePageState extends State<SpookyHomePage>
    with TickerProviderStateMixin {
  final AudioPlayer _backgroundPlayer = AudioPlayer();
  final AudioPlayer _trapSoundPlayer = AudioPlayer();
  final AudioPlayer _winningSoundPlayer = AudioPlayer();
  late AnimationController _controller;
  final Random _random = Random();

  // Character positions
  late Offset grimReaperPosition,
      batPosition,
      ghostPosition,
      pumpkinPosition,
      candyPosition;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..repeat();
    _controller.addListener(() => setState(() => _updatePositions()));
    _playBackgroundMusic();
  }

  Future<void> _playBackgroundMusic() async {
    await _backgroundPlayer.setLoopMode(LoopMode.one);
    await _backgroundPlayer
        .setAsset('assets/background music/halloween-background.mp3');
    _backgroundPlayer.play();
  }

  Future<void> _playTrapSound() async {
    await _trapSoundPlayer.setAsset('assets/trap sound/halloween-trap.mp3');
    _trapSoundPlayer.play();
  }

  Future<void> _playWinningSound() async {
    await _winningSoundPlayer.setAsset(
        'assets/winning sound/winning-sound.mp3'); // Correct path for winning sound
    _winningSoundPlayer.play();
  }

  Offset _randomPosition(Size size, double imgSize) => Offset(
        _random.nextDouble() * (size.width - imgSize),
        _random.nextDouble() * (size.height - imgSize),
      );

  void _updatePositions() {
    final size = MediaQuery.of(context).size;
    grimReaperPosition = _randomPosition(size, 100);
    batPosition = _randomPosition(size, 300);
    ghostPosition = _randomPosition(size, 400);
    pumpkinPosition = _randomPosition(size, 500);
    candyPosition = _randomPosition(size, 100); // Candy's position
  }

  @override
  void dispose() {
    _controller.dispose();
    _backgroundPlayer.dispose();
    _trapSoundPlayer.dispose();
    _winningSoundPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imgSize = 200.0;
    return Scaffold(
      appBar: AppBar(title: const Text('Spooky Characters')),
      body: Stack(
        children: [
          _buildCharacter(
              grimReaperPosition, 'grim-reaper.jpg', imgSize, _playTrapSound),
          _buildCharacter(
              batPosition, 'halloween-bat.png', imgSize, _playTrapSound),
          _buildCharacter(
              ghostPosition, 'halloween-ghost.png', imgSize, _playTrapSound),
          _buildCharacter(pumpkinPosition, 'halloween-pumpkin.jpg', imgSize,
              _playTrapSound),
          _buildWinningCharacter(candyPosition, 'candy.jpg', imgSize,
              _playWinningSound), // Candy is the winning element
        ],
      ),
    );
  }

  Widget _buildCharacter(Offset position, String image, double size,
      [Function? onTap]) {
    return AnimatedPositioned(
      duration: const Duration(seconds: 10),
      top: position.dy,
      left: position.dx,
      child: GestureDetector(
        onTap: onTap != null ? () => onTap() : null,
        child: Image.asset('assets/images/$image', width: size, height: size),
      ),
    );
  }

  Widget _buildWinningCharacter(
      Offset position, String image, double size, Function onTap) {
    return AnimatedPositioned(
      duration: const Duration(seconds: 10),
      top: position.dy,
      left: position.dx,
      child: GestureDetector(
        onTap: () {
          onTap(); // Play the winning sound
          _showWinningMessage(); // Show the winning message
        },
        child: Image.asset('assets/images/$image', width: size, height: size),
      ),
    );
  }

  void _showWinningMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('You Found It!'),
        content: const Text('Congratulations, you found the hidden candy!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
