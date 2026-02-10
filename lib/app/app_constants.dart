/// Global constants for the MODY AI app
class AppConstants {
  AppConstants._(); // Private constructor to prevent instantiation

  /// Drawing categories used for upload and filtering
  /// These categories are used when users upload drawings and filter them
  static const List<String> drawingCategories = [
    'Landscape',
    'Portraiture',
    'Still life',
    'Figurative',
    'Line Art',
    'Water Colors',
    'Oil Painting',
    'Abstract',
    'Realism',
  ];

  /// Inspiration categories used for the inspiration flow
  /// These are separate from drawing categories as they represent inspiration themes
  static const List<String> inspirationCategories = [
    'Nature',
    'Modern',
    'Abstract',
    'Portraits',
    'Anything',
  ];
}
