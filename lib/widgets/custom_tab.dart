import 'package:flutter/material.dart';

enum BorderRadiusType { topLeft, topRight, bottomLeft, bottomRight }

Widget customTab({
  required String title,
  required int value,
  required int selectedIndex,
  required int index,
  required VoidCallback onTap,
}) {
  final bool isSelected = index == selectedIndex;
  final Color activeColor = Colors.red;
  final Color inactiveColor = Colors.black;
  final Color bgHighlight = Colors.red.withAlpha(20);
  final Color bgDefault = Colors.white;

  TextStyle textStyle(bool selected) => TextStyle(
    color: selected ? activeColor : inactiveColor,
    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
  );

  return GestureDetector(
    onTap: onTap,
    child: Stack(
      children: [
        _buildBackgroundLayer(index, selectedIndex, bgHighlight, bgDefault),
        _buildForegroundLayer(
          title: title,
          value: value,
          isSelected: isSelected,
          index: index,
          selectedIndex: selectedIndex,
          textStyle: textStyle,
          bgHighlight: bgHighlight,
        ),
      ],
    ),
  );
}

Widget _buildBackgroundLayer(
  int index,
  int selectedIndex,
  Color highlight,
  Color bgDefault,
) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 20),
    decoration: BoxDecoration(
      color: _getBgColor(index, selectedIndex, highlight, bgDefault, false),
    ),
  );
}

Widget _buildForegroundLayer({
  required String title,
  required int value,
  required bool isSelected,
  required int index,
  required int selectedIndex,
  required TextStyle Function(bool) textStyle,
  required Color bgHighlight,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 20),
    decoration: BoxDecoration(
      color: _getBgColor(index, selectedIndex, bgHighlight, Colors.white, true),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(
          _shouldRound(index, selectedIndex, BorderRadiusType.topLeft) ? 20 : 0,
        ),
        topRight: Radius.circular(
          _shouldRound(index, selectedIndex, BorderRadiusType.topRight)
              ? 20
              : 0,
        ),
        bottomLeft: Radius.circular(isSelected ? 20 : 0),
        bottomRight: Radius.circular(isSelected ? 20 : 0),
      ),
    ),
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textStyle(isSelected)),
          Text(value.toString(), style: textStyle(isSelected)),
        ],
      ),
    ),
  );
}

// Define combinaciones de bordes redondeados según index y selectedIndex
bool _shouldRound(int index, int selectedIndex, BorderRadiusType type) {
  const borderRules = {
    // index: {selectedIndex: [allowedRadius]}
    0: {
      1: [BorderRadiusType.topRight],
    },
    1: {
      0: [BorderRadiusType.topLeft],
      2: [BorderRadiusType.topRight],
    },
    2: {
      1: [BorderRadiusType.topLeft],
    },
  };

  return borderRules[index]?[selectedIndex]?.contains(type) ?? false;
}

// Define combinaciones de colores para cada index y selectedIndex
Color _getBgColor(
  int index,
  int selectedIndex,
  Color highlight,
  Color fallback,
  bool isSuperior,
) {
  const bgMatrix = [
    // index 0
    [true, false, false],
    // index 1
    [false, true, false],
    // index 2
    [false, false, true],
  ];

  if (index >= bgMatrix.length || selectedIndex >= bgMatrix[index].length) {
    return fallback;
  }

  bool isHighlight = bgMatrix[index][selectedIndex];
  return isSuperior
      ? (isHighlight ? highlight : fallback)
      : (isHighlight ? fallback : highlight);
}
