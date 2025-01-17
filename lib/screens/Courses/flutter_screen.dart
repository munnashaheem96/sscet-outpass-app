import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:first_app/screens/home_screen.dart';

class FlutterScreen extends StatefulWidget {
  const FlutterScreen({super.key});

  @override
  State<FlutterScreen> createState() => _FlutterScreenState();
}

class _FlutterScreenState extends State<FlutterScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the video player with the asset video
    _controller = VideoPlayerController.asset('assets/videos/flutter.mp4')
      ..initialize().then((_) {
        setState(() {}); // Refresh to show the video player once initialized
      })
      ..setLooping(true); // Enable looping for the video
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    size: 30,
                  ),
                ),
                const Text(
                  'Flutter',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications,
                    color: Color(0xFF6649EF),
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : const CircularProgressIndicator(), // Show loading indicator while initializing
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_controller.value.isPlaying) {
                      _controller.pause(); // Pause video if playing
                    } else {
                      _controller.play(); // Play video if paused
                    }
                    setState(() {});
                  },
                  child: Text(_controller.value.isPlaying ? 'Pause' : 'Play'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
