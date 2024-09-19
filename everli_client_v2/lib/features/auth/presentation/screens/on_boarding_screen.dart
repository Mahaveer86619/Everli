import 'package:everli_client_v2/features/auth/presentation/widgets/onboarding_tile.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  _changeScreen(String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  List<Widget> onBoardingPages = [
    const OnBoardingCard(
      title: 'Effortlessly Achieve Your Goals Together',
      description:
          'Everli is your all-in-one event management app designed to empower teams of all shapes and sizes to achieve their goals seamlessly.',
      path: 'assets/images/onboarding_1.svg',
    ),
    const OnBoardingCard(
      title: 'Organize Events, Assign Tasks, Collaborate Seamlessly',
      description:
          'Create events (projects), invite team members, and define clear goals with ease. Collaborate effectively with built-in chat, video conferencing, and document sharing features.',
      path: 'assets/images/onboarding_2.svg',
    ),
    const OnBoardingCard(
      title: 'Stay Ahead of the Curve with AI Assistance',
      description:
          'Leverage Everli\'s smart task allocation, predictive analytics, and a virtual assistant to optimize workflows and stay ahead of challenges.',
      path: 'assets/images/onboarding_3.svg',
    ),
    const OnBoardingCard(
      title: 'Unlock Gamified Engagement',
      description:
          'Motivate your team and celebrate progress with Everli\'s engaging features. Earn points, badges, and climb the leaderboards to keep your team energized and focused on success.',
      path: 'assets/images/onboarding_4.svg',
    ),
  ];

  final _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildBody(context),
      ),
    );
  }

  _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  _changeScreen('/sign-in');
                },
                child: Text(
                  'Skip',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                _pageController.animateToPage(
                  index,
                  duration: Durations.short3,
                  curve: Curves.easeIn,
                );
              },
              children: onBoardingPages,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SmoothPageIndicator(
                controller: _pageController,
                count: onBoardingPages.length,
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  if (_pageController.page == onBoardingPages.length - 1) {
                    _changeScreen('/sign-in');
                  } else {
                    _pageController.animateToPage(
                      _pageController.page!.round() + 1,
                      duration: Durations.short3,
                      curve: Curves.easeIn,
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: Theme.of(context).colorScheme.background,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
