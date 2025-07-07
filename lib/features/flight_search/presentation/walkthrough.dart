import 'package:flightapp/features/flight_search/presentation/search_form.dart';
import 'package:flutter/material.dart';

class WalkthroughPage extends StatefulWidget {
  const WalkthroughPage({super.key});

  @override
  State<WalkthroughPage> createState() => _WalkthroughPageState();
}

class _WalkthroughPageState extends State<WalkthroughPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<_WalkthroughData> pages = [
    _WalkthroughData(
      bgColor: const Color(0xFF3CA1FF),
      imagePath: 'assets/images/pix1.png',
      title: 'Search Flights Instantly',
      subtitle: 'Find the best flight deals in seconds',
    ),
    _WalkthroughData(
      bgColor: const Color(0xFF9B7EE8),

      imagePath: 'assets/images/pix3.png',
      title: 'Compare Prices Easily',
      subtitle:
          'Find the best deals on flights from multiple airlines in one place',
    ),
    _WalkthroughData(
      bgColor: const Color(0xFFfe9a79),
      imagePath: 'assets/images/pix2.png',
      title: 'Book with confidence',
      subtitle: 'Secure your travel plans with our reliable booking process',
    ),
  ];

  void _nextPage() {
    if (_currentIndex < pages.length - 1) {
      _pageController.animateToPage(
        _currentIndex + 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SearchFlightsPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: pages.length,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemBuilder: (context, index) {
          final page = pages[index];
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Container(
              key: ValueKey(index),
              color: page.bgColor,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(page.imagePath, height: 280),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    page.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    page.subtitle,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Dots with animation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      pages.length,
                      (dotIndex) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == dotIndex ? 16 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color:
                              _currentIndex == dotIndex
                                  ? Colors.white
                                  : Colors.white54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      _currentIndex == pages.length - 1
                          ? 'Get Started'
                          : 'Next',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WalkthroughData {
  final Color bgColor;
  final String imagePath;
  final String title;
  final String subtitle;

  _WalkthroughData({
    required this.bgColor,
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });
}
