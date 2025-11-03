import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class ApiService {
  // API Key Anda yang sudah terisi
  static const String _apiKey = 'ed47b07e4189d75a98be3a0e146d009e'; 
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> _fetchMovies(String endpoint) async {
    final response = await http.get(Uri.parse('$_baseUrl/$endpoint?api_key=$_apiKey'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> results = data['results']; 
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load movies from $endpoint');
    }
  }

  Future<Map<String, dynamic>> getMovieCredits(int movieId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/$movieId/credits?api_key=$_apiKey')
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Mengembalikan body JSON yang berisi 'cast' dan 'crew'
    } else {
      throw Exception('Failed to load movie credits for ID $movieId');
    }
  }
  
  // FUNGSI MENGAMBIL VIDEO (TRAILER)
  Future<String?> getMovieVideos(int movieId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/$movieId/videos?api_key=$_apiKey')
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final videos = data['results'] as List<dynamic>?;

      if (videos != null) {
        // Cari video yang bertipe 'Trailer' dan bersumber dari 'YouTube'
        final trailer = videos.firstWhere(
          (v) => v['type'] == 'Trailer' && v['site'] == 'YouTube',
          orElse: () => null,
        );
        return trailer != null ? trailer['key'] : null;
      }
      return null;
    } else {
      print('Failed to load movie videos for ID $movieId. Status: ${response.statusCode}');
      return null;
    }
  }

  // --- FUNGSI BARU: MENGAMBIL ULASAN (REVIEWS) ---
  Future<List<Map<String, dynamic>>> getMovieReviews(int movieId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/$movieId/reviews?api_key=$_apiKey')
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Mengembalikan daftar ulasan (list of maps)
      return (data['results'] as List<dynamic>?)
          ?.cast<Map<String, dynamic>>() ?? [];
    } else {
      print('Failed to load movie reviews for ID $movieId. Status: ${response.statusCode}');
      throw Exception('Failed to load movie reviews');
    }
  }
  // ------------------------------------------------

  Future<List<Movie>> searchMovies(String query) async {
    if (query.trim().isEmpty) {
      return []; 
    }
    final url = '$_baseUrl/search/movie?api_key=$_apiKey&query=${Uri.encodeQueryComponent(query)}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> results = data['results'];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load search results');
    }
  }

  Future<List<Movie>> getNowPlayingMovies() {
    return _fetchMovies('movie/now_playing');
  }

  Future<List<Movie>> getTrendingMovies() {
    return _fetchMovies('trending/movie/week');
  }

  Future<List<Movie>> getPopularMovies() {
    return _fetchMovies('movie/popular');
  }

  Future<List<Movie>> getTopRatedMovies() {
    return _fetchMovies('movie/top_rated');
  }
}