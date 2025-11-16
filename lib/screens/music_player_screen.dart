import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/song_model.dart';
import '../providers/music_player_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/song_item.dart';
import '../widgets/music_progress_bar.dart';
import '../widgets/play_pause_button.dart';
import '../widgets/rotating_album_art.dart';
import '../widgets/theme_switcher.dart';
import 'favorites_screen.dart';

// BACKGROUND EFFECTS
import '../background_effects/floating_blobs.dart';
import '../background_effects/music_particles.dart';
import '../background_effects/waveform_background.dart';

class MusicPlayerScreen extends ConsumerWidget {
  const MusicPlayerScreen({super.key});

  void _showPlaylistModal(BuildContext context, MusicState state, AppTheme currentTheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildPlaylistModal(state, context, currentTheme),
    );
  }

  Widget _buildPlaylistModal(MusicState state, BuildContext context, AppTheme currentTheme) {
    final backgroundGradient = AppThemes.getBackgroundGradient(currentTheme);
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: backgroundGradient,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Icon(Icons.queue_music, color: Theme.of(context).colorScheme.primary, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Playlist',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                const Spacer(),
                Text(
                  '${state.songs.length} songs',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          
          // Divider
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
          ),
          
          // Playlist Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: state.songs.length,
              itemBuilder: (context, index) {
                return SongItem(
                  song: state.songs[index],
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(musicPlayerProvider);
    final notifier = ref.read(musicPlayerProvider.notifier);
    final themeState = ref.watch(themeProvider);

    final currentSong = state.currentSong;
    final isPlaying = state.playerState == PlayerState.playing;
    final backgroundGradient = AppThemes.getBackgroundGradient(themeState.currentTheme);

    return Scaffold(
      body: Stack(
        children: [

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: backgroundGradient,
              ),
            ),
          ),
          
          //Floating Blobs
          FloatingBlobs(),
          
          // Waveform Background
          WaveformBackground(),
          
          // Music Particles
          if (isPlaying) MusicParticles(),

          // Konten utama
          SafeArea(
            child: Column(
              children: [
                // AppBar
                AppBar(
                  title: Text(
                    'Melody Stream',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  foregroundColor: Theme.of(context).colorScheme.onBackground,
                  elevation: 0,
                  actions: [
                    IconButton(
                      icon: Icon(Icons.favorite, color: Theme.of(context).colorScheme.onBackground),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FavoritesScreen()),
                        );
                      },
                      tooltip: 'View Favorites',
                    ),
                    const ThemeSwitcher(),
                  ],
                ),
                
                Expanded(
                  flex: 3,
                  child: _buildNowPlayingSection(currentSong, isPlaying, notifier, state, context),
                ),

                Expanded(
                  flex: 1,
                  child: _buildPlaylistSection(state, () => _showPlaylistModal(context, state, themeState.currentTheme), context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNowPlayingSection(
    Song currentSong,
    bool isPlaying,
    MusicPlayerNotifier notifier,
    MusicState state,
    BuildContext context,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RotatingAlbumArt(
              imagePath: currentSong.imagePath,
              isPlaying: isPlaying,
            ),
            
            const SizedBox(height: 30),
            
            Column(
              children: [
                Text(
                  currentSong.title,
                  style: AppThemes.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  currentSong.artist,
                  style: AppThemes.inter(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 25),
            
            // Progress Bar
            const MusicProgressBar(),
            
            const SizedBox(height: 25),
            
            // Volume Control
            if (state.showVolumeControl) 
              _buildVolumeControl(notifier, state, context),
            
            const SizedBox(height: 15),
            
            // Control Buttons
            _buildControlButtons(notifier, state, context),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildVolumeControl(MusicPlayerNotifier notifier, MusicState state, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(
            Icons.volume_down_rounded,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Theme.of(context).colorScheme.primary,
                inactiveTrackColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
                thumbColor: Theme.of(context).colorScheme.primary,
                overlayColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                trackHeight: 3,
              ),
              child: Slider(
                value: state.volume,
                onChanged: (value) {
                  notifier.setVolume(value);
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.volume_up_rounded,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons(MusicPlayerNotifier notifier, MusicState state, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Speaker Button
          _buildControlButton(
            icon: state.volume == 0 ? Icons.volume_off_rounded : 
                  state.volume < 0.5 ? Icons.volume_down_rounded : Icons.volume_up_rounded,
            isActive: state.showVolumeControl,
            onPressed: notifier.toggleVolumeControl,
            tooltip: 'Volume',
            context: context,
          ),
          
          // Previous Button
          _buildControlButton(
            icon: Icons.skip_previous_rounded,
            onPressed: notifier.previous,
            size: 28,
            context: context,
          ),
          
          // Play/Pause Button
          const PlayPauseButton(),
          
          // Next Button
          _buildControlButton(
            icon: Icons.skip_next_rounded,
            onPressed: notifier.next,
            size: 28,
            context: context,
          ),
          
          // Repeat Button
          _buildRepeatButton(notifier, state, context),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required BuildContext context,
    bool isActive = false,
    double size = 24,
    String tooltip = '',
  }) {
    return IconButton(
      iconSize: size,
      icon: Icon(icon),
      onPressed: onPressed,
      tooltip: tooltip,
      style: IconButton.styleFrom(
        foregroundColor: isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onBackground,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget _buildRepeatButton(MusicPlayerNotifier notifier, MusicState state, BuildContext context) {
    IconData icon;
    Color color;
    String tooltip;

    switch (state.repeatMode) {
      case RepeatMode.none:
        icon = Icons.repeat_rounded;
        color = Theme.of(context).colorScheme.onBackground;
        tooltip = 'Repeat Off';
      case RepeatMode.repeatOne:
        icon = Icons.repeat_one_rounded;
        color = Theme.of(context).colorScheme.primary;
        tooltip = 'Repeat One';
      case RepeatMode.repeatAll:
        icon = Icons.repeat_rounded;
        color = Theme.of(context).colorScheme.primary;
        tooltip = 'Repeat All';
    }

    return IconButton(
      iconSize: 24,
      icon: Icon(icon),
      onPressed: notifier.toggleRepeat,
      tooltip: tooltip,
      style: IconButton.styleFrom(
        foregroundColor: color,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget _buildPlaylistSection(MusicState state, VoidCallback onTap, BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Handle bar
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            // Playlist Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.queue_music, color: Theme.of(context).colorScheme.primary, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    'Playlist',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${state.songs.length} songs',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.keyboard_arrow_up_rounded,
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
                    size: 20,
                  ),
                ],
              ),
            ),
            
            // Playlist Items
            Expanded(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.songs.length > 2 ? 2 : state.songs.length,
                itemBuilder: (context, index) {
                  return SongItem(
                    song: state.songs[index],
                    index: index,
                  );
                },
              ),
            ),
            
            // Show More Text
            if (state.songs.length > 2)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tap to show all ${state.songs.length} songs',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}