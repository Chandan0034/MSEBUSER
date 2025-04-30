import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static final LocalDatabase _instance = LocalDatabase._internal();
  static Database? _database;

  factory LocalDatabase() => _instance;

  LocalDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'media_data.db'),
      version: 3, // Increment the version to trigger migration
      onCreate: (db, version) async {
        // Create both tables on initial creation
        await db.execute(
            '''
          CREATE TABLE media (
            id TEXT PRIMARY KEY,
            file_url TEXT NOT NULL,
            file_type TEXT NOT NULL,
            description TEXT
          )
          '''
        );

        await db.execute(
            '''
          CREATE TABLE location_status (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            status TEXT NOT NULL
          )
          '''
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Drop and recreate the media table to remove latitude and longitude
          await db.execute("DROP TABLE IF EXISTS media");
          await db.execute(
              '''
            CREATE TABLE media (
              id TEXT PRIMARY KEY,
              file_url TEXT NOT NULL,
              file_type TEXT NOT NULL,
              description TEXT
            )
            '''
          );
        }
        if (oldVersion < 3) {
          // Add location_status table if not already present
          await db.execute(
              '''
            CREATE TABLE location_status (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              status TEXT NOT NULL
            )
            '''
          );
        }
      },
    );
  }

  // Insert Media
  Future<void> insertMedia({
    required String fileUrl,
    required String fileType,
    required String description,
    required String id,
  }) async {
    try {
      final db = await database;

      final data = {
        'id': id,
        'file_url': fileUrl,
        'file_type': fileType,
        'description': description,
      };

      await db.insert(
        'media',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      print("Media inserted successfully: $data");
    } catch (e) {
      print("Error Local Database insert: ${e.toString()}");
    }
  }

  // Fetch All Media
  Future<List<Map<String, dynamic>>> fetchAllMedia() async {
    final db = await database;
    return await db.query('media');
  }

  // Fetch Media by ID
  Future<List<Map<String, dynamic>>> fetchMediaById(String id) async {
    final db = await database;
    return await db.query(
      'media',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Set Location Status
  Future<void> setLocationStatus(String status) async {
    try {
      final db = await database;

      // Clear the previous status to maintain a single record
      await db.delete('location_status');

      await db.insert(
        'location_status',
        {'status': status},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      print("Location status updated: $status");
    } catch (e) {
      print("Error updating location status: ${e.toString()}");
    }
  }

  // Get Location Status
  Future<String> getLocationStatus() async {
    try {
      final db = await database;
      final result = await db.query('location_status');
      if (result.isNotEmpty) {
        return result.first['status'] as String;
      }
      return "off"; // Default to "off" if no status exists
    } catch (e) {
      print("Error fetching location status: ${e.toString()}");
      return "off";
    }
  }
}
