import 'package:flutter/material.dart';

class StorySection extends StatefulWidget {
  const StorySection({super.key});

  @override
  State<StorySection> createState() => _StorySectionState();
}

class _StorySectionState extends State<StorySection> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;

    return Container(
      height: MediaQuery.of(context).size.height,
      color: const Color(0xFFF8EDEB),
      padding: EdgeInsets.symmetric(
        vertical: 40,
        horizontal: isWide ? 100 : 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Nuestra historia',
            style: TextStyle(
              fontSize: isWide ? 32 : 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF6D6875),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: isWide ? _buildWideLayout() : _buildColumnLayout(),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnLayout() {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            physics: const PageScrollPhysics(),
            children: [
              _buildImage('assets/images/historia1.jpg'),
              _buildImage('assets/images/historia2.jpg'),
              _buildImage('assets/images/historia3.jpg'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Nos conocimos hace unos años...\nY desde entonces, cada paso nos ha traído hasta aquí.\nGracias por acompañarnos en este día tan especial.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF444444),
          ),
        ),
      ],
    );
  }

  Widget _buildWideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            children: [
              SizedBox(
                height: 400,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  physics: const PageScrollPhysics(),
                  children: [
                    _buildImage('assets/images/historia1.jpg'),
                    _buildImage('assets/images/historia2.jpg'),
                    _buildImage('assets/images/historia3.jpg'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _currentPage > 0
                        ? () => _goToPage(_currentPage - 1)
                        : null,
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  IconButton(
                    onPressed: _currentPage < 2
                        ? () => _goToPage(_currentPage + 1)
                        : null,
                    icon: const Icon(Icons.arrow_forward_ios),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(width: 40),
        const Expanded(
          child: Text(
            'Nos conocimos hace unos años...\nY desde entonces, cada paso nos ha traído hasta aquí.\nGracias por acompañarnos en este día tan especial.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF444444),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImage(String path) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          path,
          fit: BoxFit.contain,
          width: 300,
        ),
      ),
    );
  }
}
