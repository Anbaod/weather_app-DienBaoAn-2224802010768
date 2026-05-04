import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF1c2632),
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.white70,
          currentIndex: selectedIndex,
          onTap: onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang Chủ"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Tìm Kiếm"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Cài Đặt"),
          ],
        ),
      ),
    );
  }
}