// lib/screens/search_screen.dart (VERSI PERBAIKAN FINAL)

import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../services/api_services.dart';
import 'detail_screen.dart'; // Import DetailScreen untuk navigasi

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService _apiService = ApiService();
  List<Movie> _searchResults = [];
  bool _isLoading = false;
  String _errorMessage = 'Masukkan kata kunci untuk mencari film.';
  TextEditingController _searchController = TextEditingController();

  void _performSearch(String query) async {
    query = query.trim();
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _errorMessage = 'Masukkan kata kunci untuk mencari film.';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final results = await _apiService.searchMovies(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
        if (results.isEmpty) {
          _errorMessage = 'Tidak ada hasil ditemukan untuk "$query".';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat hasil pencarian. Cek koneksi Anda.';
        _isLoading = false;
      });
    }
  }
  
  // Widget untuk menampilkan card film dalam GridView
  Widget _buildMovieCard(Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(movie: movie),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            // Gambar Poster
            Expanded(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                        movie.fullPosterUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) => 
                            Container(color: Colors.grey, child: const Center(child: Icon(Icons.movie_creation_outlined, color: Colors.white54))),
                    ),
                ),
            ),
            const SizedBox(height: 4),
            // Judul
            Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
        ],
      ),
    );
  }

  // --- IMPLEMENTASI BUILD YANG HILANG/TERLUPAKAN ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('Search', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          // Input Pencarian
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onSubmitted: _performSearch, 
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Cari film...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.red),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[900],
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    _performSearch('');
                  },
                ),
              ),
            ),
          ),

          // Area Hasil
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.red))
                : _errorMessage.isNotEmpty && _searchResults.isEmpty
                    ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.white54)))
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, 
                          childAspectRatio: 0.45, 
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          return _buildMovieCard(_searchResults[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}