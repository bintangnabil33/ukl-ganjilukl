// lib/views/main_view.dart
import 'package:flutter/material.dart';
import 'package:ukl/controlers/book_controllers.dart';
import 'home_view.dart';
import 'linimasa_view.dart';
import 'profile.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int index = 0;

  // Controller tunggal (singleton)
  final BookController controller = BookController();

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    // Inisialisasi halaman hanya sekali
    pages = [
      HomeView(controller: controller),
      LinimasaView(controller: controller),
      ProfileView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (value) {
          setState(() => index = value);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: "Linimasa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}
