import 'dart:io';

import 'package:draw_together/data/local/app_database.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_router.dart';
import '../../app/app_constants.dart';

class UploadDetailsPage extends StatefulWidget {
  final String imagePath;

  const UploadDetailsPage({super.key, required this.imagePath});

  @override
  State<UploadDetailsPage> createState() => _UploadDetailsPageState();
}

class _UploadDetailsPageState extends State<UploadDetailsPage> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  final List<String> _selectedCategories = [];
  DateTime _date = DateTime.now();

  late final AppDatabase db;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    db = AppDatabase();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    db.close();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (_isSaving) return;

    final rawName = _nameCtrl.text.trim();

    if (rawName.isEmpty) {
      _showFloatingSnackBar('Name is required');
      return;
    }

    if (_selectedCategories.isEmpty) {
      _showFloatingSnackBar('Please select at least one category');
      return;
    }

    setState(() => _isSaving = true);

    try {
      await db
          .into(db.drawings)
          .insert(
            DrawingsCompanion.insert(
              name: rawName,
              description: Value(
                _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
              ),
              category: Value(_selectedCategories.join(', ')),
              imagePath: widget.imagePath,
              date: _date,
            ),
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).clearSnackBars();
      context.go(AppRoutes.progress, extra: {'banner': 'Drawing saved'});
    } catch (e) {
      if (!mounted) return;
      _showFloatingSnackBar('Error saving: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showFloatingSnackBar(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 96),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ✅ Fullscreen image preview
  void _openImageFullscreen() {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: InteractiveViewer(
                child: Image.file(File(widget.imagePath)),
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------- UI helpers (consistent style) ----------

  BoxDecoration get _cardDecoration => BoxDecoration(
    color: Colors.white.withOpacity(0.85),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.white.withOpacity(0.9), width: 1),
  );

  OutlineInputBorder get _fieldBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Colors.black.withOpacity(0.12)),
  );

  InputDecoration _fieldDecoration({
    required String label,
    String? hint,
    bool requiredField = false,
  }) {
    return InputDecoration(
      labelText: requiredField ? '$label *' : label,
      hintText: hint,
      filled: true,
      fillColor: Colors.white.withOpacity(0.90), // ✅ white input
      border: _fieldBorder,
      enabledBorder: _fieldBorder,
      focusedBorder: _fieldBorder.copyWith(
        borderSide: BorderSide(
          color: Colors.black.withOpacity(0.35),
          width: 1.2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      initialDate: _date,
      builder: (context, child) {
        final base = Theme.of(context);

        final scheme = base.colorScheme.copyWith(
          // Main surfaces
          surface: Colors.white,
          onSurface: Colors.black,

          // Selected day / header
          primary: Colors.black,
          onPrimary: Colors.white,

          // Material 3 uses these a lot (these are often the "pink" source)
          primaryContainer: Colors.black,
          onPrimaryContainer: Colors.white,

          secondary: Colors.black,
          onSecondary: Colors.white,
          secondaryContainer: Colors.black,
          onSecondaryContainer: Colors.white,

          // Also sometimes used for outlines / focus
          outline: Colors.black26,
        );

        return Theme(
          data: base.copyWith(
            dialogBackgroundColor: Colors.white,
            colorScheme: scheme,

            // ✅ remove Material3 tinting that can look pink
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,

            datePickerTheme: DatePickerThemeData(
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.white,
              headerBackgroundColor: Colors.white,
              headerForegroundColor: Colors.black,
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) return Colors.black;
                return Colors.black;
              }),
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected))
                  return Colors.black12;
                return Colors.transparent;
              }),
              dayOverlayColor: WidgetStatePropertyAll(Colors.black12),
              todayForegroundColor: WidgetStatePropertyAll(Colors.black),
              todayBackgroundColor: WidgetStatePropertyAll(Colors.transparent),
              todayBorder: BorderSide(color: Colors.black12),
              yearForegroundColor: WidgetStatePropertyAll(Colors.black),
              yearOverlayColor: WidgetStatePropertyAll(Colors.black12),
            ),

            // ✅ button pressed/overlay colors
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(Colors.black),
                overlayColor: WidgetStatePropertyAll(Colors.black12),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) setState(() => _date = picked);
  }

  String get _dateLabel => '${_date.day}/${_date.month}/${_date.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // ✅ consistent with global background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Upload Drawing',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ✅ Clickable image preview (styled card)
            GestureDetector(
              onTap: _openImageFullscreen,
              child: Container(
                height: 220,
                decoration: _cardDecoration,
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(widget.imagePath),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.zoom_in,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _nameCtrl,
              decoration: _fieldDecoration(
                label: 'Name',
                hint: 'Required',
                requiredField: true,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: _fieldDecoration(
                label: 'Description',
                hint: 'Optional',
              ),
            ),

            const SizedBox(height: 12),

            // ✅ Category section in a white box (consistent with Level/Description)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: _cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category *',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: AppConstants.drawingCategories.map((category) {
                      final selected = _selectedCategories.contains(category);

                      return FilterChip(
                        label: Text(
                          category,
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                        selected: selected,
                        showCheckmark: false,
                        backgroundColor: Colors.white.withOpacity(0.85),
                        selectedColor: Colors.white,
                        side: BorderSide(
                          color: selected
                              ? Colors.black.withOpacity(0.35)
                              : Colors.black.withOpacity(0.12),
                        ),
                        onSelected: (value) {
                          setState(() {
                            value
                                ? _selectedCategories.add(category)
                                : _selectedCategories.remove(category);
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ✅ Date button in the same style family
            OutlinedButton(
              onPressed: _pickDate,
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.85),
                side: BorderSide(color: Colors.black.withOpacity(0.12)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 14,
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Date: $_dateLabel',
                  style: TextStyle(color: Colors.black87, fontSize: 15),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSaving ? null : () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.70),
                      side: BorderSide(color: Colors.black.withOpacity(0.12)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black45,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 17,
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
    );
  }
}
