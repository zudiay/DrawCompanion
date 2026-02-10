import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/local/app_database.dart';

class FeedbackPage extends StatefulWidget {
  final List<Drawing> drawings;

  const FeedbackPage({
    super.key,
    required this.drawings,
  });

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int _currentIndex = 0;
  late final AppDatabase db;
  late final List<Drawing> _sortedDrawings;

  @override
  void initState() {
    super.initState();
    db = AppDatabase();
    // Sort drawings by date (oldest first for chronological feedback)
    _sortedDrawings = List.from(widget.drawings)
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  @override
  void dispose() {
    db.close();
    super.dispose();
  }

  Drawing get _currentDrawing => _sortedDrawings[_currentIndex];

  bool get _hasPrevious => _currentIndex > 0;
  bool get _hasNext => _currentIndex < _sortedDrawings.length - 1;

  void _goToPrevious() {
    if (_hasPrevious) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  void _goToNext() {
    if (_hasNext) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  String _getFeedbackText() {
    // Static feedback text based on the paper prototype
    if (_sortedDrawings.length == 1) {
      return 'Your drawing shows good technique. Keep practicing to improve further!';
    }

    final position = _currentIndex + 1;
    final total = _sortedDrawings.length;

    if (position == 1) {
      return 'Your first drawing lacked perspective. But in 2nd and 3rd drawings, you improved your technique significantly.';
    } else if (position == total) {
      return 'In your final drawing, the lines are improved. Keep drawing!';
    } else {
      return 'You are making good progress! Your technique is improving with each drawing.';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_sortedDrawings.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Feedback'),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(
          child: Text('No drawings available for feedback'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Feedback', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Drawing Info Section (Title, Category, Date) - Consistent with detail pages
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentDrawing.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (_currentDrawing.category != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _currentDrawing.category!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Text(
                      '${_currentDrawing.date.day}/${_currentDrawing.date.month}/${_currentDrawing.date.year}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                            fontSize: 16
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Page Indicator
                Text(
                  '${_currentIndex + 1}/${_sortedDrawings.length}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                ),
              ],
            ),
          ),

          // Main Drawing Display Area
          Expanded(
            child: Stack(
              children: [
                // Drawing Image - Tappable for zoom
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () => _showFullScreenImage(context, _currentDrawing.imagePath),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Center(
                                child: Image.file(
                                  File(_currentDrawing.imagePath),
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey.shade200,
                                      child: const Center(
                                        child: Icon(
                                          Icons.image_not_supported,
                                          size: 64,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              // Tap indicator overlay
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
                  ),
                ),

                // Navigation Arrows
                if (_hasPrevious)
                  Positioned(
                    left: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: _goToPrevious,
                      ),
                    ),
                  ),

                if (_hasNext)
                  Positioned(
                    right: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: _goToNext,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Feedback Text Section - Fixed height to prevent image movement
          Container(
            height: 160, // Fixed height to prevent layout shifts
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      _getFeedbackText(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.5,
                            fontSize: 20,
                          ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Image.asset(
                  'assets/images/brush_mascot.png',
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          fit: StackFit.expand,
          children: [
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade800,
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 64,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              right: 16,
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
