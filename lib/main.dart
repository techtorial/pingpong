import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'shared/theme/app_theme.dart';
import 'core/providers/robot_providers.dart';
import 'services/storage/storage_service.dart';
import 'features/device_connect/device_connect_screen.dart';
import 'features/live_control/live_control_screen.dart';
import 'features/presets/presets_screen.dart';
import 'features/drill_builder/drill_builder_screen.dart';
import 'features/session/session_screen.dart';
import 'features/settings/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage service
  final storageService = SqliteStorageService();
  await storageService.initialize();
  
  runApp(
    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storageService),
      ],
      child: const TableTennisRobotApp(),
    ),
  );
}

class TableTennisRobotApp extends ConsumerWidget {
  const TableTennisRobotApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Table Tennis Robot Controller',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

final _router = GoRouter(
  initialLocation: '/device-connect',
  routes: [
    GoRoute(
      path: '/device-connect',
      name: 'device-connect',
      builder: (context, state) => const DeviceConnectScreen(),
    ),
    GoRoute(
      path: '/live-control',
      name: 'live-control',
      builder: (context, state) => const LiveControlScreen(),
    ),
    GoRoute(
      path: '/presets',
      name: 'presets',
      builder: (context, state) => const PresetsScreen(),
    ),
    GoRoute(
      path: '/drill-builder',
      name: 'drill-builder',
      builder: (context, state) => const DrillBuilderScreen(),
    ),
    GoRoute(
      path: '/session',
      name: 'session',
      builder: (context, state) => const SessionScreen(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);