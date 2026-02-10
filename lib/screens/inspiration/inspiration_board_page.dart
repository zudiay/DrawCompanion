import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_router.dart';

const _placeholderImage = 'assets/images/brush_mascot.png';

class InspirationBoardPage extends StatefulWidget {
  const InspirationBoardPage({super.key, required this.category});

  final String category;

  @override
  State<InspirationBoardPage> createState() => _InspirationBoardPageState();
}

class _InspirationBoardPageState extends State<InspirationBoardPage> {
  static const _allCategories = ['Nature', 'Modern', 'Abstract', 'Portraits'];
  static const _levels = ['Basic', 'Basic', 'Mid', 'Mid', 'Advanced', 'Advanced'];

  late final List<({String category, String level, int slotIndex})> _items;

  @override
  void initState() {
    super.initState();
    _items = _buildItems();
  }

  List<({String category, String level, int slotIndex})> _buildItems() {
    if (widget.category != 'Anything') {
      return List.generate(_levels.length, (i) {
        final level = _levels[i];
        final slot = (i % 2) + 1;
        return (category: widget.category, level: level, slotIndex: slot);
      });
    }

    // "Anything": pick 2 random per level from all categories
    final rng = Random();
    final items = <({String category, String level, int slotIndex})>[];
    for (final level in ['Basic', 'Mid', 'Advanced']) {
      final picks = <({String category, String level, int slotIndex})>[];
      for (final cat in _allCategories) {
        picks.add((category: cat, level: level, slotIndex: 1));
        picks.add((category: cat, level: level, slotIndex: 2));
      }
      picks.shuffle(rng);
      items.addAll(picks.take(2));
    }
    return items;
  }

  static String _imagePath(String category, String level, int slot) {
    final dir = category.toLowerCase() == 'modern'
        ? 'assets/images/modern'
        : 'assets/images/inspiration/${category.toLowerCase()}';

    // log the category, level, slot for debugging
    print('Category: $category, Level: $level, Slot: $slot');
    print('Constructed path: $dir/${level.toLowerCase()}_$slot.png');
    
    
    // Nature category uses nature1.png, nature2.png, etc.
    if (category.toLowerCase() == 'nature') {
      // Map level + slot to index: Basic(1,2) -> 0,1; Mid(1,2) -> 2,3; Advanced(1,2) -> 4,5
      int index;
      switch (level) {
        case 'Basic':
          index = slot - 1; // slot 1->0, slot 2->1
          break;
        case 'Mid':
          index = slot + 1; // slot 1->2, slot 2->3
          break;
        case 'Advanced':
          index = slot + 3; // slot 1->4, slot 2->5
          break;
        default:
          index = 0;
      }
      return '$dir/nature${index + 1}.png';
    }
    
    // Other categories use the standard pattern: level_slot.png
    return '$dir/${level.toLowerCase()}_$slot.png';
  }

  @override
  Widget build(BuildContext context) {
    final sZ = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(widget.category == 'Anything'
            ? 'Mixed Inspiration'
            : '${widget.category} Inspiration',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: sZ.width * 0.05, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    "Here is the inspiration board I've prepared for you!",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 17),
                  ),
                ),
                SizedBox(
                  width: 70,
                  height: 70,
                  child: const Image(
                    image: AssetImage(_placeholderImage),
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(

              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: List.generate(_items.length, (i) {
                  final item = _items[i];
                  final path = _imagePath(item.category, item.level, item.slotIndex);
                  return InkWell(
                    onTap: () {
                      // For non-Anything, index maps directly
                      // For Anything, pass category + level info
                      context.push(
                        AppRoutes.inspiredDetail,
                        extra: {
                          'category': item.category,
                          'index': _levelToIndex(item.level, item.slotIndex),
                        },
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white.withOpacity(0.7),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: Image.asset(
                                path,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Image.asset(
                                  _placeholderImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              item.level,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'Select one to see the details.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Convert level + slot back to the flat index used by detail page metadata
  int _levelToIndex(String level, int slot) {
    switch (level) {
      case 'Basic':
        return slot - 1; // 0 or 1
      case 'Mid':
        return slot + 1; // 2 or 3
      case 'Advanced':
        return slot + 3; // 4 or 5
      default:
        return 0;
    }
  }
}
