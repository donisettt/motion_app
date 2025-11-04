import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; 
import '../models/movie_model.dart';
import '../services/api_services.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;

  const DetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final ApiService _apiService = ApiService();
  late Future<Map<String, dynamic>> _creditsFuture;
  late Future<String?> _videoKeyFuture;
  late Future<List<Map<String, dynamic>>> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    _creditsFuture = _apiService.getMovieCredits(widget.movie.id);
    _videoKeyFuture = _apiService.getMovieVideos(widget.movie.id);
    _reviewsFuture = _apiService.getMovieReviews(widget.movie.id);
  }

  void _launchTrailer(String key) async {
    final url = Uri.parse('https://www.youtube.com/watch?v=$key');

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal membuka URL trailer. Periksa konfigurasi perizinan Anda.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan saat meluncurkan: ${e.toString()}')),
        );
      }
    }
  }

  Widget _buildCastCrewCard(Map<String, dynamic> person) {
    String imageUrl = person['profile_path'] != null
        ? 'https://image.tmdb.org/t/p/w200${person['profile_path']}'
        : '';

    String name = person['name'] ?? 'Unknown';
    String role = person.containsKey('character')
        ? (person['character'] ?? 'Aktor')
        : (person['job'] ?? 'Crew');

    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 80,
                      width: 80,
                      color: Colors.grey[800],
                      child: const Icon(Icons.person, color: Colors.white70),
                    ),
                  )
                : Container(
                    height: 80,
                    width: 80,
                    color: Colors.grey[800],
                    child: const Icon(Icons.person, color: Colors.white70),
                  ),
          ),
          const SizedBox(height: 5),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          Text(
            role,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600], fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ulasan Penonton',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        
        FutureBuilder<List<Map<String, dynamic>>>(
          future: _reviewsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: CircularProgressIndicator(color: Colors.red, strokeWidth: 2)));
            } else if (snapshot.hasError) {
              return Text('Gagal memuat ulasan: ${snapshot.error}', style: const TextStyle(color: Colors.white70));
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final reviews = snapshot.data!.take(3).toList();
              
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  final author = review['author'] ?? 'Penonton Anonim';
                  final content = review['content'] ?? 'Tidak ada konten ulasan.';
                  
                  String previewContent = content;
                  if (content.length > 200) {
                    previewContent = content.substring(0, 200).replaceAll('\n', ' ') + '...';
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[800]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          author,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Divider(color: Colors.red, height: 10, thickness: 1),
                        Text(
                          previewContent,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return const Text('Belum ada ulasan untuk film ini.', style: TextStyle(color: Colors.white70));
            }
          },
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.movie.title,
                style: const TextStyle(fontSize: 16.0),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  widget.movie.backdropPath.isNotEmpty
                      ? Image.network(
                          widget.movie.fullBackdropUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: Colors.grey[900]),
                        )
                      : Container(color: Colors.grey[900]),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, -0.6),
                        end: Alignment(0.0, -0.0),
                        colors: <Color>[Color(0x60000000), Color(0x00000000)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 5),
                        Text(
                          (widget.movie.voteAverage).toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          '(${widget.movie.releaseYear})',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    FutureBuilder<String?>(
                      future: _videoKeyFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(height: 0);
                        }

                        if (snapshot.hasData && snapshot.data != null) {
                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 20),
                            child: ElevatedButton.icon(
                              onPressed: () => _launchTrailer(snapshot.data!),
                              icon: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Tonton Trailer',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 5,
                              ),
                            ),
                          );
                        }
                        return const SizedBox(height: 10);
                      },
                    ),

                    const Text(
                      'Sinopsis',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Text(
                      widget.movie.overview.isEmpty
                          ? 'Sinopsis tidak tersedia.'
                          : widget.movie.overview,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      'Cast & Crew',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    FutureBuilder<Map<String, dynamic>>(
                      future: _creditsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: CircularProgressIndicator(
                                color: Colors.red,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return const Text(
                            'Gagal memuat daftar Cast & Crew.',
                            style: TextStyle(color: Colors.white70),
                          );
                        } else if (snapshot.hasData) {
                          final castList =
                              (snapshot.data!['cast'] as List<dynamic>?) ?? [];
                          final crewList =
                              (snapshot.data!['crew'] as List<dynamic>?) ?? [];

                          final displayList = castList
                              .take(10)
                              .cast<Map<String, dynamic>>()
                              .toList();

                          final director = crewList.firstWhere(
                            (crew) => crew['job'] == 'Director',
                            orElse: () => null,
                          );
                          if (director != null &&
                              !displayList.any(
                                (p) => p['id'] == director['id'],
                              )) {
                            displayList.add(director);
                          }

                          if (displayList.isEmpty) {
                            return const Text(
                              'Data Cast & Crew tidak tersedia.',
                              style: TextStyle(color: Colors.white70),
                            );
                          }

                          return Container(
                            height: 140,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: displayList.length,
                              itemBuilder: (context, index) {
                                return _buildCastCrewCard(displayList[index]);
                              },
                            ),
                          );
                        } else {
                          return const Text(
                            'Data Cast & Crew tidak tersedia.',
                            style: TextStyle(color: Colors.white70),
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 40),

                    _buildReviewsSection(),
                    
                    const SizedBox(height: 40), 
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}