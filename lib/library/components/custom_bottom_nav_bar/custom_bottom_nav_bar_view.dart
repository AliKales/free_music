import 'package:flutter/material.dart';
import 'package:music_app/library/values.dart';
import 'package:provider/provider.dart';

import '../../providers/p_page.dart';

class _BottomNavBarItem {
  final IconData iconData;
  final String label;

  _BottomNavBarItem(this.iconData, this.label);
}

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({Key? key, required this.selectedPage})
      : super(key: key);
  final int selectedPage;

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  List<_BottomNavBarItem> items = [
    _BottomNavBarItem(Icons.home_filled, "Home"),
    _BottomNavBarItem(Icons.search, "Search"),
    _BottomNavBarItem(Icons.my_library_music, "Library"),
  ];

  int _selectedPage = 0;

  final _padding = const EdgeInsets.symmetric(vertical: 12);
  final _paddingItemIcon =
      const EdgeInsets.symmetric(horizontal: 20, vertical: 5);

  @override
  void didUpdateWidget(covariant CustomBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      _selectedPage = widget.selectedPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 0,
      color: cPrimaryColor,
      child: Padding(
        padding: _padding,
        child: Row(
          children: List.generate(
            items.length,
            (index) => _child(index),
          ),
        ),
      ),
    );
  }

  Widget _child(int index) {
    _BottomNavBarItem item = items[index];
    return Expanded(
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          Provider.of<PPage>(context, listen: false).changePage(index);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _isSelectedPage(index)
                ? Card(
                    color: cThirdColor,
                    shadowColor: Colors.transparent,
                    child: _widgetItemIcon(item),
                  )
                : _widgetItemIcon(item),
            Text(
              item.label,
              style: TextStyle(
                fontWeight: _isSelectedPage(index) ? FontWeight.bold : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _widgetItemIcon(_BottomNavBarItem item) {
    return Padding(
      padding: _paddingItemIcon,
      child: Icon(
        item.iconData,
      ),
    );
  }

  bool _isSelectedPage(int index) => index == _selectedPage;
}
