import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  late VideoPlayerController _videoController;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.asset("assets/images/Ai Error.mp4")
      ..initialize().then((_) {
        setState(() {});
        _videoController.setLooping(true);
        _videoController.setVolume(0);
        _videoController.play();
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() => isLastPage = index == 2);
          },
          children: [
            buildPage(
              title: "One Tap SOS",
              subtitle: "Send alerts to emergency contacts & police instantly.",
              image: "assets/images/sos.png",
            ),
            buildPage(
              title: "Live Tracking",
              subtitle: "Let your loved ones track your real-time location.",
              image: "assets/images/tracking.png",
            ),
            buildPage(
              title: "AI Safety Alerts",
              subtitle: "Detect suspicious behavior using smart AI tools.",
              image: "assets/images/Ai.mp4",
              isVideo: true,
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? Container(
              height: 80,
              color: Colors.pinkAccent,
              child: Center(
                child: TextButton(
                  child: Text(
                    'Get Started 💪',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    );
                  },
                ),
              ),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: Text("Skip"),
                    onPressed: () => _controller.jumpToPage(2),
                  ),
                  Center(
                    child: SmoothPageIndicator(
                      controller: _controller,
                      count: 3,
                      effect: WormEffect(
                        dotColor: Colors.grey,
                        activeDotColor: Colors.pinkAccent,
                      ),
                    ),
                  ),
                  TextButton(
                    child: Text("Next"),
                    onPressed: () => _controller.nextPage(
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildPage({
    required String title,
    required String subtitle,
    required String image,
    bool isVideo = false,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isVideo
            ? _videoController.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  )
                : CircularProgressIndicator()
            : Image.asset(image, height: 250),
        SizedBox(height: 30),
        Text(
          title,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
