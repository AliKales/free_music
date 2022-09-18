import 'package:flutter/material.dart';
import 'package:music_app/library/pages/home_page/home_page_view.dart';
import 'package:music_app/library/pages/library_page/library_page_view.dart';
import 'package:music_app/library/pages/search_page/search_page_view.dart';

class MainPagePageView extends StatefulWidget {
  const MainPagePageView({Key? key, required this.selectedPage})
      : super(key: key);

  final int selectedPage;

  @override
  State<MainPagePageView> createState() => _MainPagePageViewState();
}

class _MainPagePageViewState extends State<MainPagePageView> {
  final PageController _pageController = PageController();

  @override
  void didUpdateWidget(covariant MainPagePageView oldWidget) {
    super.didUpdateWidget(oldWidget);

    _pageController.jumpToPage(widget.selectedPage);
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: const [
        HomePageView(),
        SearchPageView(),
        LibraryPage(),
      ],
    );
  }
}
