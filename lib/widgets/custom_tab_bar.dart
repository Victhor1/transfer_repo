import 'package:flutter/material.dart';

enum BorderRadiusType { topLeft, topRight, bottomLeft, bottomRight }

class TabItem {
  final String title;
  final int value;

  TabItem({required this.title, required this.value});
}

class CustomTabBar extends StatefulWidget {
  final List<TabItem> tabs;
  final Function(int index) onTabChanged;
  final int initialIndex;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.onTabChanged,
    this.initialIndex = 0,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(widget.tabs.length, (index) {
        final tab = widget.tabs[index];
        return Expanded(
          child: _buildCustomTab(
            title: tab.title,
            value: tab.value,
            index: index,
            selectedIndex: selectedIndex,
            totalTabs: widget.tabs.length,
            onTap: () {
              setState(() => selectedIndex = index);
              widget.onTabChanged(index);
            },
          ),
        );
      }),
    );
  }

  Widget _buildCustomTab({
    required String title,
    required int value,
    required int index,
    required int selectedIndex,
    required int totalTabs,
    required VoidCallback onTap,
  }) {
    final bool isSelected = index == selectedIndex;
    final Color activeColor = Colors.red;
    final Color inactiveColor = Colors.black;
    final Color bgHighlight = Color(0xfffef0ef);
    final Color bgDefault = Colors.white;

    final BorderRadius borderRadius = BorderRadius.only(
      topLeft: Radius.circular(
        _shouldRound(index, selectedIndex, totalTabs, BorderRadiusType.topLeft)
            ? 20
            : 0,
      ),
      topRight: Radius.circular(
        _shouldRound(index, selectedIndex, totalTabs, BorderRadiusType.topRight)
            ? 20
            : 0,
      ),
      bottomLeft: Radius.circular(isSelected ? 20 : 0),
      bottomRight: Radius.circular(isSelected ? 20 : 0),
    );

    final Color bgColor = _getBgColor(
      index,
      selectedIndex,
      totalTabs,
      bgHighlight,
      bgDefault,
      true,
    );
    final TextStyle currentStyle = TextStyle(
      color: isSelected ? activeColor : inactiveColor,
      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
    );

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // Fondo estático
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: _getBgColor(
                index,
                selectedIndex,
                totalTabs,
                bgHighlight,
                bgDefault,
                false,
              ),
            ),
          ),
          // Tab con animaciones
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: borderRadius,
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    style: currentStyle,
                    child: Text(title),
                  ),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    style: currentStyle,
                    child: Text(value.toString()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldRound(
    int index,
    int selectedIndex,
    int totalTabs,
    BorderRadiusType type,
  ) {
    if (type == BorderRadiusType.topLeft && index == selectedIndex + 1) {
      return true;
    }
    if (type == BorderRadiusType.topRight && index == selectedIndex - 1) {
      return true;
    }
    return false;
  }

  Color _getBgColor(
    int index,
    int selectedIndex,
    int totalTabs,
    Color highlight,
    Color fallback,
    bool isSuperior,
  ) {
    if (index == selectedIndex) {
      return isSuperior ? highlight : fallback;
    }

    if ((index - selectedIndex).abs() == 1) {
      return isSuperior ? fallback : highlight;
    }

    return fallback;
  }
}
