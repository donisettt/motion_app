import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _buildOptionTile(BuildContext context, IconData icon, String title, VoidCallback onTap, {Color? textColor}) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Colors.white70),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 18,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Profil Pengguna',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.red.shade800,
              child: const Icon(
                Icons.person,
                size: 80,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),

            const Text(
              'Doni Setiawan Wahyono',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),

            Text(
              '23552011146@sttbandung.ac.id',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            
            _buildOptionTile(
              context, 
              Icons.favorite_border, 
              'Daftar Film Favorit', 
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mengarah ke halaman Favorite...'))
                );
              } 
            ),
            _buildOptionTile(
              context, 
              Icons.history, 
              'Riwayat Tontonan', 
              () {
                 ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Riwayat Tontonan (Belum Diimplementasi)'))
                );
              } 
            ),
            _buildOptionTile(
              context, 
              Icons.settings, 
              'Pengaturan Akun', 
              () {
                 ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pengaturan Akun (Belum Diimplementasi)'))
                );
              } 
            ),
            const Divider(color: Colors.grey, height: 40, thickness: 0.5),
            
            _buildOptionTile(
              context, 
              Icons.logout, 
              'Keluar', 
              () {
                 ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Anda Berhasil Logout (Dummy)'))
                );
              },
              textColor: Colors.red
            ),
          ],
        ),
      ),
    );
  }
}