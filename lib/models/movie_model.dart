// lib/models/movie_model.dart (VERSI FINAL)

class Movie {
  final int id; // Tambahan: ID unik film
  final String title;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;
  // Tambahan: overview (sinopsis) untuk digunakan di DetailScreen
  final String overview; 

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.overview,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int? ?? 0, // Parsing ID
      title: json['title'] ?? json['name'] ?? 'No Title',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      
      // PERBAIKAN VOTE AVERAGE (Mengamankan parsing)
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0, 
      
      // PERBAIKAN RELEASE DATE
      releaseDate: json['release_date'] ?? json['first_air_date'] ?? '',
      
      // Tambahan: overview
      overview: json['overview'] ?? 'Sinopsis tidak tersedia.',
    );
  }

  String get fullPosterUrl => 'https://image.tmdb.org/t/p/w500$posterPath';
  String get fullBackdropUrl => 'https://image.tmdb.org/t/p/w500$backdropPath';
  
  String get releaseYear {
    if (releaseDate.isEmpty) return 'N/A';
    // Menghindari error jika format tanggal tidak standar
    try {
      return releaseDate.split('-').first;
    } catch (_) {
      return 'N/A';
    }
  }
}
