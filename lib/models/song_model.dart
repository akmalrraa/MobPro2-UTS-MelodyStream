import 'package:equatable/equatable.dart';

class Song extends Equatable {
  final String title;
  final String artist;
  final String duration;
  final String assetPath;
  final String imagePath;

  const Song({
    required this.title,
    required this.artist,
    required this.duration,
    required this.assetPath,
    required this.imagePath,
  });

  @override
  List<Object> get props => [title, artist, duration, assetPath, imagePath];
}

final List<Song> songs = [
  Song(
    title: "Titik Nadir",
    artist: "Kahitna",
    duration: "05:04",
    assetPath: "assets/audio/Titik_Nadir.mp3",
    imagePath: "assets/images/titik_nadir.jpg",
  ),
  Song(
    title: "Blue Jeans",
    artist: "Gangga Kusuma",
    duration: "03:38",
    assetPath: "assets/audio/blue_jeans.mp3",
    imagePath: "assets/images/blue_jeans.jpg",
  ),
  Song(
    title: "Bergema Sampai Selamanya",
    artist: "Nadhif Basalamah",
    duration: "03:18",
    assetPath: "assets/audio/bergema_sampai_selamanya.mp3",
    imagePath: "assets/images/bergema.jpg",
  ),
  Song(
    title: "Hingga Tua Bersama",
    artist: "Rizky Febian",
    duration: "04:42",
    assetPath: "assets/audio/hingga_tua_bersama.mp3",
    imagePath: "assets/images/hingga_tua_bersama.jpg",
  ),
  Song(
    title: "Best Friend",
    artist: "Rex Orange Country",
    duration: "04:22",
    assetPath: "assets/audio/Best_Friend.mp3",
    imagePath: "assets/images/best_friend.jpg",
  ),
];