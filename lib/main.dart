// lib/main.dart (VERSI FINAL DENGAN NAVIGASI DAN PROFILE)

import 'package:flutter/material.dart';
import 'services/api_services.dart';
import 'models/movie_model.dart';
import 'widgets/now_playing_carousel.dart';
import 'widgets/horizontal_movie_list.dart';
// --- IMPORT HALAMAN BARU ---
import 'screens/search_screen.dart';
import 'screens/profile_screen.dart'; // BARU: Import ProfileScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App Layout',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ApiService _apiService;
  
  // Variabel untuk menampung Future data (hanya untuk halaman Home)
  late Future<List<Movie>> _nowPlayingFuture;
  late Future<List<Movie>> _trendingFuture;
  late Future<List<Movie>> _popularFuture;
  late Future<List<Movie>> _topRatedFuture;

  // --- VARIABEL DAN DAFTAR HALAMAN ---
  int _selectedIndex = 0; // Index 0 = Home
  late List<Widget> _widgetOptions; // Daftar widget/halaman

  // Fungsi untuk membuat konten halaman Home
  Widget _buildHomePageBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          NowPlayingCarousel(movieFuture: _nowPlayingFuture),
          const SizedBox(height: 20),
          HorizontalMovieList(title: "Trending", movieFuture: _trendingFuture),
          const SizedBox(height: 20),
          HorizontalMovieList(title: "Popular", movieFuture: _popularFuture),
          const SizedBox(height: 20),
          HorizontalMovieList(title: "Top Rated", movieFuture: _topRatedFuture),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _nowPlayingFuture = _apiService.getNowPlayingMovies();
    _trendingFuture = _apiService.getTrendingMovies();
    _popularFuture = _apiService.getPopularMovies();
    _topRatedFuture = _apiService.getTopRatedMovies();

    // Inisialisasi daftar widget/halaman
    _widgetOptions = <Widget>[
      _buildHomePageBody(), // Index 0: Halaman Home
      SearchScreen(),       // Index 1: Halaman Search
      Center(child: const Text('Favorite Page (Coming Soon)', style: TextStyle(color: Colors.white))),
      const ProfileScreen(), // BARU: Index 3: Halaman Profile
      Center(child: const Text('More Page (Coming Soon)', style: TextStyle(color: Colors.white))),
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
      // AppBar hanya tampil di halaman Home (index 0)
      appBar: _selectedIndex == 0
          ? AppBar(
              backgroundColor: Colors.black,
              elevation: 0,
              title: const Text(
                'Motion',
                style: TextStyle(color: Colors.red, fontSize: 28, fontWeight: FontWeight.w900),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: Colors.white, size: 28),
                  onPressed: () {},
                ),
                const SizedBox(width: 10),
              ],
            )
          : null, // AppBar null di halaman lain

      // Tampilkan Widget yang dipilih
      body: _widgetOptions.elementAt(_selectedIndex),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex, // Set index aktif
        onTap: _onItemTapped, // Tambahkan fungsi tap
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'More'),
        ],
      ),
    );
  }
}