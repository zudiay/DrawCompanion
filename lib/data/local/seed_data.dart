import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'app_database.dart';

/// Seed data utility for testing
/// Set [enabled] to true to automatically populate database with dummy data
class SeedData {
  static const bool enabled = true; // Set to true to enable seed data

  /// Seeds the database with dummy drawings if enabled
  static Future<void> seedIfEnabled(AppDatabase db) async {
    if (!enabled) return;

    // Clear any old seed data first (both old "Sample Drawing" entries and new seed names)
    await _clearOldSeedData(db);

    final existing = await db.getAllDrawings();
    // Check if new seed data already exists
    final seedNames = [
      'Alpine Meadow Bridge',
      'The Alchemist\'s Study',
      'Harvest Breakfast',
      'The Scholar\'s Gaze',
      'Friendly Face',
    ];
    final hasNewSeeds = existing.any((d) => seedNames.contains(d.name));
    
    if (hasNewSeeds) {
      // New seed data already exists, skip
      return;
    }

    await _seedDrawings(db);
  }

  /// Clears old seed data (both old "Sample Drawing" entries and new seed names)
  static Future<void> _clearOldSeedData(AppDatabase db) async {
    final drawings = await db.getAllDrawings();
    final seedNames = [
      'Alpine Meadow Bridge',
      'The Alchemist\'s Study',
      'Harvest Breakfast',
      'The Scholar\'s Gaze',
      'Friendly Face',
      'Mountains',
      'Falling Flowers',
    ];
    
    for (final drawing in drawings) {
      // Clear old "Sample Drawing" entries or new seed names
      if (drawing.name.startsWith('Sample Drawing') || seedNames.contains(drawing.name)) {
        await db.deleteDrawingById(drawing.id);
        // Optionally delete the image file
        try {
          final file = File(drawing.imagePath);
          if (await file.exists()) {
            await file.delete();
          }
        } catch (e) {
          // Ignore file deletion errors
        }
      }
    }
  }

  static Future<void> _seedDrawings(AppDatabase db) async {
    final appDir = await getApplicationDocumentsDirectory();
    final drawingsDir = Directory(p.join(appDir.path, 'drawings'));
    if (!await drawingsDir.exists()) {
      await drawingsDir.create(recursive: true);
    }

    // Seed data with specific metadata
    final seedData = [
      (
        imageAsset: 'assets/images/progress_seed/seed1.png',
        name: 'Alpine Meadow Bridge',
        category: 'Landscape',
        description: 'A scenic drawing of a small wooden footbridge crossing a mountain stream. This piece focuses on drawing structural lines alongside organic shapes like wildflowers and flowing water, providing a great exercise in composition and depth.',
        date: DateTime(2026, 2, 7),
      ),
      (
        imageAsset: 'assets/images/progress_seed/seed2.png',
        name: 'The Alchemist\'s Study',
        category: 'Still life',
        description: 'An intricate arrangement featuring a vintage glass carafe, a silver goblet, and a halved pomegranate on a draped velvet cloth. This piece demands mastery of light refraction through glass, metallic luster, and the organic, ruby-like details of fruit seeds.',
        date: DateTime(2026, 1, 15),
      ),
      (
        imageAsset: 'assets/images/progress_seed/seed3.png',
        name: 'Harvest Breakfast',
        category: 'Still life',
        description: 'A traditional still life arrangement featuring a ceramic pitcher, a woven basket, and a few scattered apples. This exercise focuses on capturing the different volumes of round objects and practicing the rhythmic patterns of woven textures.',
        date: DateTime(2026, 1, 22),
      ),
      (
        imageAsset: 'assets/images/progress_seed/seed4.png',
        name: 'The Scholar\'s Gaze',
        category: 'Portraiture',
        description: 'A three-quarter view portrait of an elderly person with expressive features. This drawing focuses on capturing character through fine lines around the eyes and practicing the soft, blended values of skin tones and a simple headwrap.',
        date: DateTime(2026, 1, 8),
      ),
      (
        imageAsset: 'assets/images/progress_seed/seed5.png',
        name: 'Friendly Face',
        category: 'Portraiture',
        description: 'A simple, front-facing portrait of a smiling person. This exercise focuses on basic facial symmetry and using soft, light pencil strokes to define the eyes, nose, and mouth without complex anatomical detail.',
        date: DateTime(2026, 1, 28),
      ),
      (
        imageAsset: 'assets/images/progress_seed/seed6.png',
        name: 'Mountains',
        category: 'Landscape',
        description: 'A drawing of a mountain range with a river flowing through it. This exercise focuses on capturing the different layers of the landscape and the different textures of the mountain.',
        date: DateTime(2026, 2, 1),
      ),
      (
        imageAsset: 'assets/images/progress_seed/seed7.png',
        name: 'Falling Flowers',
        category: 'Landscape',
        description: 'A drawing of a flower falling from a tree. This exercise focuses on capturing the different layers of the landscape and the different textures of the flower.',
        date: DateTime(2026, 1, 18),
      ),

    ];

    // Create drawings from seed data
    for (final seed in seedData) {
      try {
        // Load and save the image
        final imageBytes = await rootBundle.load(seed.imageAsset);
        final fileName = 'seed_${p.basename(seed.imageAsset)}';
        final imagePath = p.join(drawingsDir.path, fileName);
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(
          imageBytes.buffer.asUint8List(
            imageBytes.offsetInBytes,
            imageBytes.lengthInBytes,
          ),
        );

        await db.into(db.drawings).insert(
          DrawingsCompanion.insert(
            name: seed.name,
            description: Value(seed.description),
            category: Value(seed.category),
            imagePath: imagePath,
            date: seed.date,
          ),
        );
      } catch (e) {
        // If asset doesn't exist, skip this drawing
        debugPrint('Failed to load asset ${seed.imageAsset}: $e');
        continue;
      }
    }
  }

  /// Clears all seed data from database (both old and new)
  static Future<void> clearSeedData(AppDatabase db) async {
    await _clearOldSeedData(db);
  }
}
