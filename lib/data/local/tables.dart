import 'package:drift/drift.dart';

class Drawings extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get category => text().nullable()();

  // Store as Unix ms for simplicity (works great with DateTime in Drift).
  DateTimeColumn get date => dateTime()();

  // Path to the saved image file in app storage/cache
  TextColumn get imagePath => text().named('image_data')();
}

class InspoImages extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();
  TextColumn get level => text()();        // e.g., Beginner/Intermediate/Advanced
  TextColumn get technique => text()();    // e.g., Shading, Perspective
  TextColumn get description => text().nullable()();
}

class Feedbacks extends Table {
  IntColumn get id => integer().autoIncrement()();

  // FK to drawings.id
  IntColumn get drawingId => integer().named('drawing_id')();

  DateTimeColumn get creationDate => dateTime().named('creation_date')();

  TextColumn get feedbackText => text().nullable()();

}
