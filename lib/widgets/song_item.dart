import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/song_model.dart';
import '../providers/music_player_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/theme_provider.dart';

class SongItem extends ConsumerWidget {
  final Song song;
  final int index;

  const SongItem({
    super.key,
    required this.song,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(musicPlayerProvider);
    final favorites = ref.watch(favoritesProvider);
    final favoritesNotifier = ref.read(favoritesProvider.notifier);
    final themeState = ref.watch(themeProvider);

    final isCurrentSong = state.currentIndex == index;
    final isPlaying = state.playerState == PlayerState.playing && isCurrentSong;
    final isFavorite = favorites.contains(song);

    final gradientColors = AppThemes.getThemeGradient(themeState.currentTheme);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isCurrentSong 
            ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
            : Theme.of(context).colorScheme.surface.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: isCurrentSong
            ? Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.5), width: 1.5)
            : null,
        boxShadow: [
          if (isCurrentSong)
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Stack(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(song.imagePath),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
              if (isCurrentSong && isPlaying)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradientColors,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: gradientColors.first.withOpacity(0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.equalizer,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          title: Text(
            song.title,
            style: AppThemes.poppins(
              fontSize: 16,
              fontWeight: isCurrentSong ? FontWeight.w700 : FontWeight.w600,
              color: isCurrentSong 
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            song.artist, // INTER MEDIUM
            style: AppThemes.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isCurrentSong 
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.8)
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isFavorite ? Colors.red : Colors.transparent,
                  border: Border.all(
                    color: isFavorite ? Colors.red : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: isFavorite ? [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ] : null,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.favorite_rounded,
                    color: isFavorite ? Colors.white : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    size: 22,
                  ),
                  onPressed: () {
                    favoritesNotifier.toggleFavorite(song);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  song.duration,
                  style: AppThemes.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
          onTap: () {
            final notifier = ref.read(musicPlayerProvider.notifier);
            notifier.playSong(index);
          },
        ),
      ),
    );
  }
}