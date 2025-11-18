# Melody Stream - Music Player App

## 📋 Pengembang Aplikasi
1. Akmal Rabbih Aizar - 232101180


## 🎵 Penjelasan Aplikasi

**Melody Stream** adalah aplikasi music player premium yang menawarkan pengalaman mendengarkan musik yang imersif dengan antarmuka yang elegan dan fitur-fitur lengkap. Aplikasi ini dirancang dengan arsitektur modern menggunakan Flutter dan Riverpod untuk state management.

## 🎥 Video Demo
**Link Google Drive:** https://drive.google.com/drive/folders/15sywC1GQnNfoZBB-PNfxEzTpgDvV2r75?usp=sharing

**Video Content:**
- Splash screen animation
- Music playback demonstration  
- Playlist navigation
- Favorite system functionality
- Theme switching showcase
- Visual effects dan animations

### ✨ Fitur Utama:

#### 🎧 **Audio Playback Lengkap**
- Play/Pause dengan animasi smooth
- Next/Previous track navigation  
- Seek Control dengan progress bar interaktif
- Volume Control dengan slider dan toggle
- Repeat Modes: None, Repeat One, Repeat All

#### 🎨 **Visual Experience**
- Rotating Album Art - Album cover berputar saat musik diputar
- Multiple Themes - 5 pilihan tema (Main, Pastel Blue, Green, Purple, Pink)
- Background Effects: Floating Blobs, Music Particles, Waveform Background

#### 💾 **Music Management**
- Playlist System dengan modal bottom sheet
- Favorite System - favorite/unfavorite lagu
- Song Metadata lengkap

#### 📱 **User Experience**
- Splash Screen dengan animasi Lottie
- Responsive Design untuk berbagai ukuran layar
- Smooth Animations dan transition
- Intuitive Controls yang mudah digunakan

## 📱 Screenshot Tampilan

### Splash Screen
<img width="828" height="1792" alt="Splash Screen" src="https://github.com/user-attachments/assets/47637c6b-6c7a-4d9e-8443-3871459aff0f" />

### Music Player Screen  
<img width="828" height="1792" alt="Music Player Screen" src="https://github.com/user-attachments/assets/f5caee10-dec8-4dc9-bbaf-186658fc1f32" />

### Playlist
<img width="828" height="1792" alt="Playlist" src="https://github.com/user-attachments/assets/d05f84cc-437c-4a37-80dc-7e4e04949ab7" />

### Favorites Screen
<img width="828" height="1792" alt="Favorite" src="https://github.com/user-attachments/assets/4b023d1f-771f-4e69-b506-a8d32e0253a2" />

### Theme Switcher
<img width="828" height="1792" alt="Tema" src="https://github.com/user-attachments/assets/b12ca712-c267-44e3-80d9-7e80957280db" />

## 💻 Implementasi Requirements UTS

### ✅ 1. Widget Wajib

#### **List View/Grid View** ✅
- Digunakan dalam SongItem widget untuk menampilkan daftar lagu
- Implementasi di playlist modal dan favorites screen

#### **Animasi** ✅
- RotatingAlbumArt dengan rotation animation
- FloatingBlobs dengan floating movement
- MusicParticles yang responsive terhadap music state
- WaveformBackground dengan animated lines

#### **Custom Widget** ✅
- MusicProgressBar - Custom progress bar dengan seek
- PlayPauseButton - Animated button dengan gradient
- RotatingAlbumArt - Album art dengan rotation
- SongItem - List item untuk lagu
- ThemeSwitcher - Theme selection dialog

### ✅ 2. Stateful Widget dengan Riverpod

#### **State Management** ✅
- musicPlayerProvider - Mengelola state pemutaran musik
- favoritesProvider - Mengelola daftar favorit  
- themeProvider - Mengelola tema aplikasi

#### **Reactive UI** ✅
- Widget bereaksi terhadap state changes secara real-time
- ConsumerWidget untuk efficient rebuilds

## 📁 Struktur Project
```
lib/
├── main.dart
├── screens/
│   ├── splash_screen.dart
│   ├── music_player_screen.dart
│   └── favorites_screen.dart
├── widgets/
│   ├── music_progress_bar.dart
│   ├── play_pause_button.dart
│   ├── rotating_album_art.dart
│   ├── song_item.dart
│   ├── theme_switcher.dart
├── background_effects/
│   ├── floating_blobs.dart
│   ├── music_particles.dart
│   └── waveform_background.dart
├── providers/
│   ├── theme_provider.dart
│   ├── music_player_provider.dart
│   └── favorites_provider.dart
├── models/
│   └── song_model.dart
└── services/
    └── audio_service.dart
```

## 📦 Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  flutter_riverpod: ^2.4.9
  audioplayers: ^5.0.0
  equatable: ^2.0.5
  lottie: ^2.7.0
```

---

**© 2025 Melody Stream - Developed for UTS Mobile Programming 2 - Universitas Teknologi Bandung**
