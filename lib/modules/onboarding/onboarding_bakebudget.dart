import 'package:bakebudget_pastry_office_185t/modules/onboarding/preium_bakebudget.dart';
import 'package:flutter/material.dart';

class OnboardingBakeBudget extends StatefulWidget {
  const OnboardingBakeBudget({super.key});

  @override
  State<OnboardingBakeBudget> createState() => _OnboardingBakeBudgetState();
}

class _OnboardingBakeBudgetState extends State<OnboardingBakeBudget> {
  final PageController _pageController = PageController();

  final List<Map<String, String>> _onboardingData = [
    {
      'image': 'assets/images/0.1.1.png',
      "buttonText": "Next",
      "color": "#1DACD6",
    },
    {
      'image': 'assets/images/0.1.2.png',
      "buttonText": "Next",
      "color": "#00897B",
    },
    {
      'image': 'assets/images/0.1.3.png',
      "buttonText": "Next",
      "color": "#7CB342",
    },
  ];

  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const PreiumBakebudget()),
        (route) => false,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: _onboardingData.length,
        itemBuilder: (context, index) {
          final data = _onboardingData[index];
          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(data["image"]!, fit: BoxFit.fill),
              ),
              Positioned(
                bottom: 50,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _previousPage,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Color(0xFF343434),

                          fontWeight: FontWeight.w400,
                          fontSize: 16,

                          fontFamily: 'SF Compact Rounded',
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _nextPage,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Color(
                            int.parse("0xFF" + data["color"]!.substring(1)),
                          ),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          data["buttonText"]!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'SF Compact Rounded',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
