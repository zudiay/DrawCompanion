import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Drawings, InspoImages, Feedbacks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // ---------------------------------------------------------------------------
  // DRAWINGS
  // ---------------------------------------------------------------------------

  /// ذخیره عکس در حافظه اپ و برگرداندن مسیر جدید
  Future<String> saveImageToAppStorage(String sourcePath) async {
    final appDir = await getApplicationDocumentsDirectory();
    final drawingsDir = Directory(p.join(appDir.path, 'drawings'));

    if (!await drawingsDir.exists()) {
      await drawingsDir.create(recursive: true);
    }

    final extension = p.extension(sourcePath); // .jpg / .png
    final fileName =
        'drawing_${DateTime.now().millisecondsSinceEpoch}$extension';

    final newPath = p.join(drawingsDir.path, fileName);

    await File(sourcePath).copy(newPath);
    return newPath;
  }


  Future<int> insertDrawingWithImagePath(String imagePath) {
    return into(drawings).insert(
     DrawingsCompanion.insert(
  name: 'My drawing',
  imagePath: imagePath,
  date: DateTime.now(),
)
    );
  }

  Future<List<Drawing>> getAllDrawings() => select(drawings).get();

  Future<int> deleteDrawingById(int id) =>
      (delete(drawings)..where((t) => t.id.equals(id))).go();

  // ---------------------------------------------------------------------------
  // INSPO
  // ---------------------------------------------------------------------------

  Future<int> insertInspo(InspoImagesCompanion entry) =>
      into(inspoImages).insert(entry);

  Future<List<InspoImage>> getAllInspo() => select(inspoImages).get();

  // ---------------------------------------------------------------------------
  // FEEDBACK
  // ---------------------------------------------------------------------------

  Future<int> insertFeedback(FeedbacksCompanion entry) =>
      into(feedbacks).insert(entry);

  Future<List<Feedback>> getFeedbackForDrawing(int drawingId) {
    return (select(feedbacks)
          ..where((f) => f.drawingId.equals(drawingId)))
        .get();
  }
}

// -----------------------------------------------------------------------------
// DB CONNECTION
// -----------------------------------------------------------------------------

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'mody_ai.sqlite'));
    return NativeDatabase(file);
  });
}
