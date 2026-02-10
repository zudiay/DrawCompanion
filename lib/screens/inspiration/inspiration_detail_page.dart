import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


const _placeholderImage = 'assets/images/brush_mascot.png';

// Key: 'category_index' (e.g. abstract_0). Add more when you add category images.
final Map<String, ({String title, String level, String description})> _metadata = {
  // Abstract
  'abstract_0': (title: 'Abstract Gaze', level: 'Basic', description: 'A striking abstract face with unique floral elements around the eyes, rendered with bold lines.'),
  'abstract_1': (title: 'Flowing Ribbons', level: 'Basic', description: 'A dynamic abstract piece featuring a gracefully swirling, ribbon-like form made of many fine parallel lines.'),
  'abstract_2': (title: 'Boat on Ripples', level: 'Mid', description: 'An aerial view of a boat gently resting on water, with detailed ripples depicted by intricate line patterns.'),
  'abstract_3': (title: 'Radial Geometry', level: 'Mid', description: 'A composition exploring the interplay of radial and parallel lines centered around a dark focal point.'),
  'abstract_4': (title: 'Textured Organic Form', level: 'Advanced', description: 'An intricately drawn organic shape with exceptionally detailed linear textures, conveying depth and form.'),
  'abstract_5': (title: 'Figures on a Grid', level: 'Advanced', description: 'An aerial perspective of human figures navigating a geometrically patterned ground, rendered with expressive lines.'),
  // Nature
  'nature_0': (title: 'Golden Solitude', level: 'Basic', description: 'A peaceful and simplified landscape featuring a rising sun over calm hills. Its bold shapes and minimal color palette make it an ideal starting point for new artists.'),
  'nature_1': (title: 'Moonlit Pine', level: 'Basic', description: 'A charming and accessible sketch of a single pine tree under a full moon. This design uses organic, hand-drawn strokes and simple layering, perfect for beginners practicing basic nature shapes and textures.'),
  'nature_2': (title: 'Autumn Lakeside Path', level: 'Mid', description: 'A scenic view of a winding path leading toward a calm lake, flanked by two detailed autumn trees. This piece introduces perspective and varied textures like wood grain and falling leaves, ideal for intermediate artists looking for a gentle challenge.'),
  'nature_3': (title: 'Tropical Shoreline', level: 'Mid', description: 'A vibrant coastal scene featuring a leaning palm tree and textured rocks along the water\'s edge. This drawing focuses on layering different natural elements and practicing the rhythmic patterns of palm fronds and gentle waves.'),
  'nature_4': (title: 'Guardian of the Mist', level: 'Advanced', description: 'A high-detail forest scene featuring a majestic stag standing in a foggy woodland clearing. This composition requires advanced skills in rendering realistic textures, atmospheric depth, and complex light filtering through a dense canopy of ancient oaks.'),
  'nature_5': (title: 'Crystal Canyon Falls', level: 'Advanced', description: 'A powerful waterfall cascading over tiered, jagged rock formations into a clear basin. This piece challenges the artist to master the movement of falling water, realistic transparency in the pool below, and the sharp, multi-dimensional shadows of a rocky canyon.'),
    // Portraits
  'portraits_0': (title: 'Bright Smile Sketch', level: 'Basic', description: 'A clean, friendly pencil portrait with simple facial features—great for practicing proportions and line confidence.'),
  'portraits_1': (title: 'Kitten Gaze', level: 'Basic', description: 'A cute kitten portrait with soft fur texture and big eyes—practice light shading and short strokes.'),
  'portraits_2': (title: 'Summer Sunflower', level: 'Mid', description: 'A watercolor-style portrait with a sunflower—good for skin tones, soft edges, and gentle gradients.'),
  'portraits_3': (title: 'Cheerful Cartoon Boy', level: 'Mid', description: 'A vibrant cartoon portrait—practice clean shapes, highlights, and smooth color fills.'),
  'portraits_4': (title: 'Grit Portrait Study', level: 'Advanced', description: 'A high-contrast gritty portrait—focus on structure, planes of the face, and textured shading.'),
  'portraits_5': (title: 'Surreal Dalí-Inspired Muse', level: 'Advanced', description: 'A surreal portrait study—practice dramatic lighting, symbolic elements, and complex composition.'),

  // Modern
  'modern_0': (title: 'Midnight Blooms', level: 'Basic', description: 'Bold, stylized flowers built from simple shapes and clean lines. Great for practicing confident linework and balanced spacing.'),
  'modern_1': (title: 'Crimson Cat', level: 'Basic', description: 'A playful, graphic cat portrait with flat colors and strong outlines. Focus on symmetry, clean fills, and crisp edges.'),
  'modern_2': (title: 'Soft Pencil Study', level: 'Mid', description: 'A gentle graphite portrait with light shading and soft transitions. Practice facial proportions and subtle value changes.'),
  'modern_3': (title: 'Petal Mandala', level: 'Mid', description: 'A detailed floral mandala with repeating patterns. Work on radial symmetry and consistent line weight.'),
  'modern_4': (title: 'Waves & Hat', level: 'Advanced', description: 'A stylized portrait with flowing hair and layered textures. Focus on contrast, texture variety, and composition balance.'),
  'modern_5': (title: 'Golden Gallop', level: 'Advanced', description: 'Dynamic horses in motion with warm tones and bold shapes. Practice motion lines, anatomy rhythm, and dramatic lighting.'),
};

String _levelLabel(String level) {
  switch (level) {
    case 'Basic': return 'Easy';
    case 'Mid': return 'Medium';
    default: return level;
  }
}

void _showZoomableImage(BuildContext context, String path) {
  showDialog(
    context: context,
    barrierColor: Colors.black87,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        fit: StackFit.expand,
        children: [
          InteractiveViewer(
            minScale: 0.5,
            maxScale: 4,
            child: Center(
              child: Image.asset(
                path,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Image.asset(_placeholderImage, fit: BoxFit.contain),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(ctx).padding.top + 8,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ),
        ],
      ),
    ),
  );
}

class InspirationDetailPage extends StatelessWidget {
  const InspirationDetailPage({super.key, required this.category, required this.index});

  final String category;
  final int index;

  static String imagePath(String category, int index) {
    final dir = category.toLowerCase() == 'modern'
        ? 'assets/images/modern'
        : 'assets/images/inspiration/${category.toLowerCase()}';
    
    // Nature category uses nature1.png, nature2.png, etc.
    if (category.toLowerCase() == 'nature') {
      return '$dir/nature${index + 1}.png';
    }
    
    
    // Other categories use the standard pattern: level_slot.png
    const levels = ['Basic', 'Basic', 'Mid', 'Mid', 'Advanced', 'Advanced'];
    final level = levels[index];
    final slot = (index % 2) + 1;
    return '$dir/${level.toLowerCase()}_$slot.png';
  }

  @override
  Widget build(BuildContext context) {
    final key = '${category.toLowerCase()}_$index';
    final meta = _metadata[key] ?? (title: 'Inspiration', level: 'Basic', description: 'No description.');
    final path = imagePath(category, index);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(meta.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () => _showZoomableImage(context, path),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        path,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          _placeholderImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.zoom_in,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text('Level', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black, fontSize: 20)),
                  const SizedBox(width: 10),
                  Text(_levelLabel(meta.level), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 20),
Container(
  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
  decoration: BoxDecoration(
    color: Colors.grey.shade100,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Description',
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(color: Colors.black, fontSize: 20),
      ),
      const SizedBox(height: 8),
      Text(
        meta.description,
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(height: 1.5, fontSize: 16),
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
