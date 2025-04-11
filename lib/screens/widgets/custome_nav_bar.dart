import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const items = [
      {'icon': Icons.home, 'label': "Home"},
      {'icon': Icons.map, 'label': "Map"},
      {'icon': Icons.person, 'label': "Profile"},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = currentIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      items[index]['icon'] as IconData,
                      color: isSelected ? Colors.blue : Colors.grey,
                      size: isSelected ? 28 : 24,
                    ),
                    const SizedBox(height: 4),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 250),
                      style: TextStyle(
                        color: isSelected ? Colors.blue : Colors.grey,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: isSelected ? 14 : 12,
                      ),
                      child: Text(items[index]['label'] as String),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
