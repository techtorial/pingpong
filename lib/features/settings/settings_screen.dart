import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/theme/app_theme.dart';
import '../../core/providers/robot_providers.dart';
import '../../shared/widgets/settings_section.dart';
import '../../shared/widgets/settings_tile.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isDarkMode = false;
  bool _hapticFeedback = true;
  bool _soundEffects = true;
  bool _voiceCues = false;
  bool _autoReconnect = true;
  bool _safetyConfirmations = true;
  String _frequencyUnits = 'balls/min';
  int _stepSize = 1;
  int _minValue = 0;
  int _maxValue = 20;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/live-control'),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Appearance
            SettingsSection(
              title: 'Appearance',
              children: [
                SettingsTile(
                  title: 'Dark Mode',
                  subtitle: 'Use dark theme',
                  trailing: Switch(
                    value: _isDarkMode,
                    onChanged: (value) => setState(() => _isDarkMode = value),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Controls
            SettingsSection(
              title: 'Controls',
              children: [
                SettingsTile(
                  title: 'Frequency Units',
                  subtitle: 'Display units for frequency',
                  trailing: DropdownButton<String>(
                    value: _frequencyUnits,
                    onChanged: (value) => setState(() => _frequencyUnits = value!),
                    items: const [
                      DropdownMenuItem(value: 'balls/min', child: Text('Balls per minute')),
                      DropdownMenuItem(value: 'balls/sec', child: Text('Balls per second')),
                    ],
                  ),
                ),
                SettingsTile(
                  title: 'Step Size',
                  subtitle: 'Increment/decrement step size',
                  trailing: DropdownButton<int>(
                    value: _stepSize,
                    onChanged: (value) => setState(() => _stepSize = value!),
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('1')),
                      DropdownMenuItem(value: 2, child: Text('2')),
                      DropdownMenuItem(value: 5, child: Text('5')),
                    ],
                  ),
                ),
                SettingsTile(
                  title: 'Value Range',
                  subtitle: 'Min: $_minValue, Max: $_maxValue',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: _minValue > 0 ? () => setState(() => _minValue--) : null,
                        icon: const Icon(Icons.remove),
                      ),
                      Text('$_minValue-$_maxValue'),
                      IconButton(
                        onPressed: _maxValue < 100 ? () => setState(() => _maxValue++) : null,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Feedback
            SettingsSection(
              title: 'Feedback',
              children: [
                SettingsTile(
                  title: 'Haptic Feedback',
                  subtitle: 'Vibrate on button presses',
                  trailing: Switch(
                    value: _hapticFeedback,
                    onChanged: (value) => setState(() => _hapticFeedback = value),
                  ),
                ),
                SettingsTile(
                  title: 'Sound Effects',
                  subtitle: 'Play sounds for actions',
                  trailing: Switch(
                    value: _soundEffects,
                    onChanged: (value) => setState(() => _soundEffects = value),
                  ),
                ),
                SettingsTile(
                  title: 'Voice Cues',
                  subtitle: 'Announce drill steps',
                  trailing: Switch(
                    value: _voiceCues,
                    onChanged: (value) => setState(() => _voiceCues = value),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Connection
            SettingsSection(
              title: 'Connection',
              children: [
                SettingsTile(
                  title: 'Auto Reconnect',
                  subtitle: 'Automatically reconnect to last device',
                  trailing: Switch(
                    value: _autoReconnect,
                    onChanged: (value) => setState(() => _autoReconnect = value),
                  ),
                ),
                SettingsTile(
                  title: 'Safety Confirmations',
                  subtitle: 'Confirm before power on',
                  trailing: Switch(
                    value: _safetyConfirmations,
                    onChanged: (value) => setState(() => _safetyConfirmations = value),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Data
            SettingsSection(
              title: 'Data',
              children: [
                SettingsTile(
                  title: 'Export Data',
                  subtitle: 'Export presets and drills',
                  trailing: const Icon(Icons.upload),
                  onTap: () => _exportData(),
                ),
                SettingsTile(
                  title: 'Import Data',
                  subtitle: 'Import presets and drills',
                  trailing: const Icon(Icons.download),
                  onTap: () => _importData(),
                ),
                SettingsTile(
                  title: 'Clear Data',
                  subtitle: 'Delete all presets and drills',
                  trailing: const Icon(Icons.delete, color: AppColors.errorColor),
                  onTap: () => _clearData(),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // About
            SettingsSection(
              title: 'About',
              children: [
                SettingsTile(
                  title: 'Version',
                  subtitle: '1.0.0',
                  trailing: const Icon(Icons.info),
                ),
                SettingsTile(
                  title: 'Help',
                  subtitle: 'View help and documentation',
                  trailing: const Icon(Icons.help),
                  onTap: () => _showHelp(),
                ),
                SettingsTile(
                  title: 'Privacy Policy',
                  subtitle: 'View privacy policy',
                  trailing: const Icon(Icons.privacy_tip),
                  onTap: () => _showPrivacyPolicy(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export functionality not implemented yet'),
        backgroundColor: AppColors.warningColor,
      ),
    );
  }

  void _importData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Import functionality not implemented yet'),
        backgroundColor: AppColors.warningColor,
      ),
    );
  }

  void _clearData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text('This will delete all presets and drills. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement clear data
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Clear data functionality not implemented yet'),
                  backgroundColor: AppColors.warningColor,
                ),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help'),
        content: const Text('Help documentation not implemented yet.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const Text('Privacy policy not implemented yet.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}