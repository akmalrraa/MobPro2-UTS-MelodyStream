import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/song_model.dart';

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<Song>>((ref) {
  return FavoritesNotifier();
});

class FavoritesNotifier extends StateNotifier<List<Song>> {
  FavoritesNotifier() : super([]);

  void addToFavorites(Song song) {
    if (!state.contains(song)) {
      state = [...state, song];
    }
  }

  void removeFromFavorites(Song song) {
    state = state.where((s) => s != song).toList();
  }

  bool isFavorite(Song song) {
    return state.contains(song);
  }

  void toggleFavorite(Song song) {
    if (isFavorite(song)) {
      removeFromFavorites(song);
    } else {
      addToFavorites(song);
    }
  }
}