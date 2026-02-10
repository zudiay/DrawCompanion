import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:draw_together/data/local/app_database.dart';
import '../../app/app_router.dart';
import '../../app/app_constants.dart';
import '../../data/local/seed_data.dart';

class ProgressPage extends StatefulWidget {
  final String? initialBanner;

  const ProgressPage({super.key, this.initialBanner});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  late final AppDatabase db;
  late final TextEditingController _searchController;
  List<Drawing> _allDrawings = [];
  List<Drawing> _filteredDrawings = [];
  String _searchQuery = '';
  Set<String> _selectedCategories = {};
  bool _showFilterMenu = false;

  @override
  void initState() {
    super.initState();
    db = AppDatabase();
    _searchController = TextEditingController();
    _loadDrawings();
    if (widget.initialBanner != null && widget.initialBanner!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showTopBanner(widget.initialBanner!);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    db.close();
    super.dispose();
  }

  Future<void> _loadDrawings() async {
    // Seed data if enabled
    await SeedData.seedIfEnabled(db);
    
    final drawings = await db.getAllDrawings();
    setState(() {
      _allDrawings = drawings;
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<Drawing> filtered = List.from(_allDrawings);

    // Apply category filter
    if (_selectedCategories.isNotEmpty) {
      filtered = filtered.where((drawing) {
        return drawing.category != null &&
            _selectedCategories.contains(drawing.category);
      }).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((drawing) {
        final name = drawing.name.toLowerCase();
        final description = drawing.description?.toLowerCase() ?? '';
        final category = drawing.category?.toLowerCase() ?? '';
        return name.contains(query) ||
            description.contains(query) ||
            category.contains(query);
      }).toList();
    }

    setState(() {
      _filteredDrawings = filtered;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
    });
    _applyFilters();
    FocusScope.of(context).unfocus();
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
    _applyFilters();
  }

  void _resetFilters() {
    setState(() {
      _selectedCategories.clear();
      _searchQuery = '';
      _searchController.clear();
    });
    _applyFilters();
  }

  void _showTopBanner(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearMaterialBanners();
    messenger.showMaterialBanner(
      MaterialBanner(
        content: Text(message),
        backgroundColor: const Color(0xFFE8F5E9),
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        actions: [
          TextButton(
            onPressed: messenger.hideCurrentMaterialBanner,
            style: TextButton.styleFrom(foregroundColor: const Color(0xFF1B5E20)),
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) messenger.hideCurrentMaterialBanner();
    });
  }

  int get _filteredCount => _filteredDrawings.length;

  String _getEmptyStateMessage() {
    final hasFilters = _selectedCategories.isNotEmpty || _searchQuery.isNotEmpty;
    
    if (hasFilters) {
      return 'You have zero drawings for the selected filters. You can update the filters or upload your drawings first to get a review.';
    } else if (_allDrawings.isEmpty) {
      return 'No drawings yet. Upload your drawings first to get a review.';
    } else {
      return 'No drawings match your search. Try different keywords or clear the search.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.landing);
            }
          },
        ),
        title: const Text(
          'Progress',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            // Hand-drawn style - you might want to use a custom font
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          if (_showFilterMenu) {
            setState(() {
              _showFilterMenu = false;
            });
          }
        },
        child: Stack(
          children: [
          Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            hintText: 'Search',
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, color: Colors.grey),
                                    onPressed: _clearSearch,
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Filter Button
                    IconButton(
                      icon: Icon(
                        Icons.tune,
                        color: _selectedCategories.isNotEmpty
                            ? Colors.blue
                            : Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _showFilterMenu = !_showFilterMenu;
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Grid View
              Expanded(
                child: _filteredDrawings.isEmpty
                    ? Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                      )
                    : GridView.builder(
            padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: _filteredDrawings.length,
            itemBuilder: (context, index) {
                          final drawing = _filteredDrawings[index];
return InkWell(
  onTap: () {
    context.push(
                                '/drawing/details',
      extra: {
        'imagePath': drawing.imagePath,
        'name': drawing.name,
        'date': drawing.date,
                                  'description': drawing.description,
                                  'category': drawing.category,
      },
    );
  },
                            borderRadius: BorderRadius.circular(12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                  ),
                      child: Image.file(
                        File(drawing.imagePath),
                        fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  alignment: Alignment.center,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey.shade200,
                                      child: const Center(
                                        child: Icon(
                                          Icons.image_not_supported,
                                          size: 32,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),

              // Feedback Prompt Section (always show, but disable buttons when empty)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                  color: Colors.white.withOpacity(0.9),

                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            _filteredCount > 0
                                ? 'You have $_filteredCount drawing${_filteredCount == 1 ? '' : 's'} for the filtered categories. Do you want to receive a feedback?'
                                : _getEmptyStateMessage(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Image.asset(
                          'assets/images/brush_mascot.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _filteredCount > 0
                                ? () {
                                    // Navigate to feedback page with filtered drawings
                                    context.push(
                                      AppRoutes.feedback,
                                      extra: _filteredDrawings,
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade800,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey.shade300,
                              disabledForegroundColor: Colors.grey.shade600,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Yes!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _filteredCount > 0
                                ? () {
                                    // User declined feedback - go to home
                                    context.go(AppRoutes.landing);
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade800,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey.shade300,
                              disabledForegroundColor: Colors.grey.shade600,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'No!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Filter Dropdown Menu
          if (_showFilterMenu)
            Positioned(
              top: 80,
              right: 8,
              child: GestureDetector(
                onTap: () {}, // Prevent closing when tapping inside
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 180, // Reduced width to prevent overflow
                    constraints: const BoxConstraints(maxHeight: 400),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(
                                child: Text(
                                  'Filter categories',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              TextButton(
                                onPressed: _resetFilters,
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Reset',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        // Category List
                        Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: AppConstants.drawingCategories.length,
                            itemBuilder: (context, index) {
                              final category =
                                  AppConstants.drawingCategories[index];
                              final isSelected =
                                  _selectedCategories.contains(category);
                              return CheckboxListTile(
                                title: Text(
                                  category,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                value: isSelected,
                                onChanged: (_) => _toggleCategory(category),
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 0,
                                ),
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

        ],
        ),
      ),
    );
  }
}
