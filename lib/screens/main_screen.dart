import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import 'detail_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  final Movie initialMovie;

  const MainScreen({super.key, required this.initialMovie});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Daftar Widget yang dapat diakses melalui Bottom Navigation Bar
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Inisialisasi daftar screen.
    // Index 0: DetailScreen dengan film yang sudah ada
    // Index 1: ProfileScreen
    _screens = <Widget>[
      DetailScreen(movie: widget.initialMovie),
      const ProfileScreen(),
      // Di masa depan, Anda bisa menambahkan 'HomeScreen()' di sini
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menampilkan screen yang terpilih
      body: _screens[_selectedIndex],
      
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Detail Film',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red, // Warna aktif
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black, // Background hitam
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Memastikan background hitam terlihat
      ),
    );
  }
}
