import 'dart:async';
import 'dart:math';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../core/constants/app_constants.dart';
import '../../models/preset.dart';
import '../../models/drill.dart';
import '../../models/drill_step.dart';
import '../../models/session.dart';

abstract class StorageService {
  Future<void> initialize();
  Future<void> dispose();
  
  // Presets
  Future<List<Preset>> getAllPresets();
  Future<Preset?> getPreset(String id);
  Future<void> savePreset(Preset preset);
  Future<void> updatePreset(Preset preset);
  Future<void> deletePreset(String id);
  
  // Drills
  Future<List<Drill>> getAllDrills();
  Future<Drill?> getDrill(String id);
  Future<void> saveDrill(Drill drill);
  Future<void> updateDrill(Drill drill);
  Future<void> deleteDrill(String id);
  
  // Sessions
  Future<List<Session>> getAllSessions();
  Future<Session?> getSession(String id);
  Future<void> saveSession(Session session);
  Future<void> updateSession(Session session);
  Future<void> deleteSession(String id);
  Future<SessionStats> getSessionStats();
}

class SqliteStorageService implements StorageService {
  Database? _database;
  
  @override
  Future<void> initialize() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, AppConstants.databaseName);
    
    _database = await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _createTables,
      onUpgrade: _upgradeTables,
    );
  }
  
  @override
  Future<void> dispose() async {
    await _database?.close();
  }
  
  Future<void> _createTables(Database db, int version) async {
    // Presets table
    await db.execute('''
      CREATE TABLE presets (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        frequency INTEGER NOT NULL,
        oscillation INTEGER NOT NULL,
        topspin INTEGER NOT NULL,
        backspin INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
    
    // Drills table
    await db.execute('''
      CREATE TABLE drills (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        loops INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
    
    // Drill steps table
    await db.execute('''
      CREATE TABLE drill_steps (
        id TEXT PRIMARY KEY,
        drill_id TEXT NOT NULL,
        duration_sec INTEGER NOT NULL,
        frequency INTEGER NOT NULL,
        oscillation INTEGER NOT NULL,
        topspin INTEGER NOT NULL,
        backspin INTEGER NOT NULL,
        frequency_range_min INTEGER,
        frequency_range_max INTEGER,
        oscillation_range_min INTEGER,
        oscillation_range_max INTEGER,
        topspin_range_min INTEGER,
        topspin_range_max INTEGER,
        backspin_range_min INTEGER,
        backspin_range_max INTEGER,
        description TEXT,
        step_order INTEGER NOT NULL,
        FOREIGN KEY (drill_id) REFERENCES drills (id) ON DELETE CASCADE
      )
    ''');
    
    // Sessions table
    await db.execute('''
      CREATE TABLE sessions (
        id TEXT PRIMARY KEY,
        start_time INTEGER NOT NULL,
        end_time INTEGER,
        total_balls_thrown INTEGER NOT NULL DEFAULT 0,
        total_duration_sec INTEGER NOT NULL DEFAULT 0,
        drill_id TEXT,
        drill_name TEXT,
        FOREIGN KEY (drill_id) REFERENCES drills (id)
      )
    ''');
    
    // Session steps table
    await db.execute('''
      CREATE TABLE session_steps (
        id TEXT PRIMARY KEY,
        session_id TEXT NOT NULL,
        start_time INTEGER NOT NULL,
        end_time INTEGER,
        frequency INTEGER NOT NULL,
        oscillation INTEGER NOT NULL,
        topspin INTEGER NOT NULL,
        backspin INTEGER NOT NULL,
        balls_thrown INTEGER NOT NULL DEFAULT 0,
        step_order INTEGER NOT NULL,
        FOREIGN KEY (session_id) REFERENCES sessions (id) ON DELETE CASCADE
      )
    ''');
    
    // Create indexes
    await db.execute('CREATE INDEX idx_presets_name ON presets (name)');
    await db.execute('CREATE INDEX idx_drills_name ON drills (name)');
    await db.execute('CREATE INDEX idx_drill_steps_drill_id ON drill_steps (drill_id)');
    await db.execute('CREATE INDEX idx_sessions_start_time ON sessions (start_time)');
    await db.execute('CREATE INDEX idx_session_steps_session_id ON session_steps (session_id)');
  }
  
  Future<void> _upgradeTables(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
  }
  
  @override
  Future<List<Preset>> getAllPresets() async {
    final db = _database;
    if (db == null) throw Exception('Database not initialized');
    
    final List<Map<String, dynamic>> maps = await db.query(
      'presets',
      orderBy: 'name ASC',
    );
    
    return maps.map((map) => Preset.fromJson(map)).toList();
  }
  
  @override
  Future<Preset?> getPreset(String id) async {
    final db = _database;
    if (db == null) throw Exception('Database not initialized');
    
    final List<Map<String, dynamic>> maps = await db.query(
      'presets',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isEmpty) return null;
    return Preset.fromJson(maps.first);
  }
  
  @override
  Future<void> savePreset(Preset preset) async {
    final db = _database;
    if (db == null) throw Exception('Database not initialized');
    
    await db.insert('presets', preset.toJson());
  }
  
  @override
  Future<void> updatePreset(Preset preset) async {
    final db = _database;
    if (db == null) throw Exception('Database not initialized');
    
    await db.update(
      'presets',
      preset.toJson(),
      where: 'id = ?',
      whereArgs: [preset.id],
    );
  }
  
  @override
  Future<void> deletePreset(String id) async {
    final db = _database;
    if (db == null) throw Exception('Database not initialized');
    
    await db.delete(
      'presets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  @override
  Future<List<Drill>> getAllDrills() async {
    final db = _database;
    if (db == null) throw Exception('Database not initialized');
    
    final List<Map<String, dynamic>> drillMaps = await db.query(
      'drills',
      orderBy: 'name ASC',
    );
    
    final List<Drill> drills = [];
    
    for (final drillMap in drillMaps) {
      final drillId = drillMap['id'] as String;
      
      // Get drill steps
      final List<Map<String, dynamic>> stepMaps = await db.query(
        'drill_steps',
        where: 'drill_id = ?',
        whereArgs: [drillId],
        orderBy: 'step_order ASC',
      );
      
      final steps = stepMaps.map((stepMap) {
        return DrillStep(
          id: stepMap['id'] as String,
          durationSec: stepMap['duration_sec'] as int,
          frequency: stepMap['frequency'] as int,
          oscillation: stepMap['oscillation'] as int,
          topspin: stepMap['topspin'] as int,
          backspin: stepMap['backspin'] as int,
          frequencyRange: stepMap['frequency_range_min'] != null
              ? RandomRange(
                  min: stepMap['frequency_range_min'] as int,
                  max: stepMap['frequency_range_max'] as int,
                )
              : null,
          oscillationRange: stepMap['oscillation_range_min'] != null
              ? RandomRange(
                  min: stepMap['oscillation_range_min'] as int,
                  max: stepMap['oscillation_range_max'] as int,
                )
              : null,
          topspinRange: stepMap['topspin_range_min'] != null
              ? RandomRange(
                  min: stepMap['topspin_range_min'] as int,
                  max: stepMap['topspin_range_max'] as int,
                )
              : null,
          backspinRange: stepMap['backspin_range_min'] != null
              ? RandomRange(
                  min: stepMap['backspin_range_min'] as int,
                  max: stepMap['backspin_range_max'] as int,
                )
              : null,
          description: stepMap['description'] as String?,
        );
      }).toList();
      
      drills.add(Drill(
        id: drillId,
        name: drillMap['name'] as String,
        description: drillMap['description'] as String?,
        loops: drillMap['loops'] as int,
        steps: steps,
        createdAt: DateTime.fromMillisecondsSinceEpoch(drillMap['created_at'] as int),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(drillMap['updated_at'] as int),
      ));
    }
    
    return drills;
  }
  
  @override
  Future<Drill?> getDrill(String id) async {
    final db = _database;
    if (db == null) throw Exception('Database not initialized');
    
    final List<Map<String, dynamic>> drillMaps = await db.query(
      'drills',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (drillMaps.isEmpty) return null;
    
    final drillMap = drillMaps.first;
    final drillId = drillMap['id'] as String;
    
    // Get drill steps
    final List<Map<String, dynamic>> stepMaps = await db.query(
      'drill_steps',
      where: 'drill_id = ?',
      whereArgs: [drillId],
      orderBy: 'step_order ASC',
    );
    
    final steps = stepMaps.map((stepMap) {
      return DrillStep(
        id: stepMap['id'] as String,
        durationSec: stepMap['duration_sec'] as int,
        frequency: stepMap['frequency'] as int,
        oscillation: stepMap['oscillation'] as int,
        topspin: stepMap['topspin'] as int,
        backspin: stepMap['backspin'] as int,
        frequencyRange: stepMap['frequency_range_min'] != null
            ? RandomRange(
                min: stepMap['frequency_range_min'] as int,
                max: stepMap['frequency_range_max'] as int,
              )
            : null,
        oscillationRange: stepMap['oscillation_range_min'] != null
            ? RandomRange(
                min: stepMap['oscillation_range_min'] as int,
                max: stepMap['oscillation_range_max'] as int,
              )
            : null,
        topspinRange: stepMap['topspin_range_min'] != null
            ? RandomRange(
                min: stepMap['topspin_range_min'] as int,
                max: stepMap['topspin_range_max'] as int,
              )
            : null,
        backspinRange: stepMap['backspin_range_min'] != null
            ? RandomRange(
                min: stepMap['backspin_range_min'] as int,
                max: stepMap['backspin_range_max'] as int,
              )
            : null,
        description: stepMap['description'] as String?,
      );
    }).toList();
    
    return Drill(
      id: drillId,
      name: drillMap['name'] as String,
      description: drillMap['description'] as String?,
      loops: drillMap['loops'] as int,
      steps: steps,
      createdAt: DateTime.fromMillisecondsSinceEpoch(drillMap['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(drillMap['updated_at'] as int),
    );
  }
  
  @override
  Future<void> saveDrill(Drill drill) async {
    final db = _database;
    if (db == null) throw Exception('Database not initialized');
    
    final batch = db.batch();
    
    // Insert drill
    batch.insert('drills', {
      'id': drill.id,
      'name': drill.name,
      'description': drill.description,
      'loops': drill.loops,
      'created_at': drill.createdAt.millisecondsSinceEpoch,
      'updated_at': drill.updatedAt.millisecondsSinceEpoch,
    });
    
    // Insert drill steps
    for (int i = 0; i < drill.steps.length; i++) {
      final step = drill.steps[i];
      batch.insert('drill_steps', {
        'id': step.id,
        'drill_id': drill.id,
        'duration_sec': step.durationSec,
        'frequency': step.frequency,
        'oscillation': step.oscillation,
        'topspin': step.topspin,
        'backspin': step.backspin,
        'frequency_range_min': step.frequencyRange?.min,
        'frequency_range_max': step.frequencyRange?.max,
        'oscillation_range_min': step.oscillationRange?.min,
        'oscillation_range_max': step.oscillationRange?.max,
        'topspin_range_min': step.topspinRange?.min,
        'topspin_range_max': step.topspinRange?.max,
        'backspin_range_min': step.backspinRange?.min,
        'backspin_range_max': step.backspinRange?.max,
        'description': step.description,
        'step_order': i,
      });
    }
    
    await batch.commit();
  }
  
  @override
  Future<void> updateDrill(Drill drill) async {
    final db = _database;
    if (db == null) throw Exception('Database not initialized');
    
    final batch = db.batch();
    
    // Update drill
    batch.update(
      'drills',
      {
        'name': drill.name,
        'description': drill.description,
        'loops': drill.loops,
        'updated_at': drill.updatedAt.millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [drill.id],
    );
    
    // Delete existing steps
    batch.delete(
      'drill_steps',
      where: 'drill_id = ?',
      whereArgs: [drill.id],
    );
    
    // Insert new steps
    for (int i = 0; i < drill.steps.length; i++) {
      final step = drill.steps[i];
      batch.insert('drill_steps', {
        'id': step.id,
        'drill_id': drill.id,
        'duration_sec': step.durationSec,
        'frequency': step.frequency,
        'oscillation': step.oscillation,
        'topspin': step.topspin,
        'backspin': step.backspin,
        'frequency_range_min': step.frequencyRange?.min,
        'frequency_range_max': step.frequencyRange?.max,
        'oscillation_range_min': step.oscillationRange?.min,
        'oscillation_range_max': step.oscillationRange?.max,
        'topspin_range_min': step.topspinRange?.min,
        'topspin_range_max': step.topspinRange?.max,
        'backspin_range_min': step.backspinRange?.min,
        'backspin_range_max': step.backspinRange?.max,
        'description': step.description,
        'step_order': i,
      });
    }
    
    await batch.commit();
  }
  
  @override
  Future<void> deleteDrill(String id) async {
    final db = _database;
    if (db == null) throw Exception('Database not initialized');
    
    await db.delete(
      'drills',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  @override
  Future<List<Session>> getAllSessions() async {
    final db = _database;
    if (db == null) throw Exception('Database not initialized');
    
    final List<Map<String, dynamic>> maps = await db.query(
      'sessions',
      orderBy: 'start_time DESC',
    );
    
    return maps.map((map) => Session.fromJson(map)).toList();
  }
  
  @override
  Future<Session?> getSession(String id) async {
    final db = _database;
    if (db == null) throw Exception('Database not initialized');
    
    final List<Map<String, dynamic>> maps = await db.query(
      'sessions',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isEmpty) return null;
    return Session.fromJson(maps.first);
  }
  
  @override
  Future<void> saveSession(Session session) async {
    final db = _database;
    if (db == null) throw Exception('Database not initialized');
    
    await db.insert('sessions', session.toJson());
  }
  
  @override
  Future<void> updateSession(Session session) async {
    final db = _database;
    if (db == null) throw Exception('Database not initialized');
    
    await db.update(
      'sessions',
      session.toJson(),
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }
  
  @override
  Future<void> deleteSession(String id) async {
    final db = _database;
    if (db == null) throw Exception('Database not initialized');
    
    await db.delete(
      'sessions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  @override
  Future<SessionStats> getSessionStats() async {
    final db = _database;
    if (db == null) throw Exception('Database not initialized');
    
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT 
        COUNT(*) as total_sessions,
        SUM(total_balls_thrown) as total_balls_thrown,
        SUM(total_duration_sec) as total_duration_sec,
        AVG(total_balls_thrown) as avg_balls_per_session,
        AVG(total_duration_sec) as avg_duration_per_session,
        MAX(start_time) as last_session_date
      FROM sessions
    ''');
    
    if (result.isEmpty) {
      return const SessionStats();
    }
    
    final row = result.first;
    return SessionStats(
      totalSessions: row['total_sessions'] as int? ?? 0,
      totalBallsThrown: row['total_balls_thrown'] as int? ?? 0,
      totalDurationSec: row['total_duration_sec'] as int? ?? 0,
      averageBallsPerSession: (row['avg_balls_per_session'] as double?) ?? 0.0,
      averageDurationPerSession: (row['avg_duration_per_session'] as double?) ?? 0.0,
      lastSessionDate: row['last_session_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(row['last_session_date'] as int)
          : null,
    );
  }
}