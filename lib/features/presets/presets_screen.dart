import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../shared/theme/app_theme.dart';
import '../../core/providers/robot_providers.dart';
import '../../models/preset.dart';
import '../../shared/widgets/preset_card.dart';
import '../../shared/widgets/preset_editor.dart';

class PresetsScreen extends ConsumerStatefulWidget {
  const PresetsScreen({super.key});

  @override
  ConsumerState<PresetsScreen> createState() => _PresetsScreenState();
}

class _PresetsScreenState extends ConsumerState<PresetsScreen> {
  @override
  Widget build(BuildContext context) {
    final presetsAsync = ref.watch(presetsNotifierProvider);
    final robotState = ref.watch(robotStateNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Presets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showPresetEditor(),
          ),
        ],
      ),
      body: SafeArea(
        child: presetsAsync.when(
          data: (presets) => _buildPresetsList(presets, robotState),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load presets',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(presetsNotifierProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPresetsList(List<Preset> presets, robotState) {
    if (presets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_outline,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No presets yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first preset to get started',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showPresetEditor(),
              icon: const Icon(Icons.add),
              label: const Text('Create Preset'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: presets.length,
      itemBuilder: (context, index) {
        final preset = presets[index];
        return PresetCard(
          preset: preset,
          onTap: () => _applyPreset(preset),
          onEdit: () => _showPresetEditor(preset: preset),
          onDelete: () => _deletePreset(preset),
        );
      },
    );
  }

  Future<void> _applyPreset(Preset preset) async {
    try {
      final robotNotifier = ref.read(robotStateNotifierProvider.notifier);
      await robotNotifier.applyPreset(preset);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Applied preset: ${preset.name}'),
            backgroundColor: AppColors.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to apply preset: $e'),
            backgroundColor: AppColors.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _deletePreset(Preset preset) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Preset'),
        content: Text('Are you sure you want to delete "${preset.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final presetsNotifier = ref.read(presetsNotifierProvider.notifier);
        await presetsNotifier.deletePreset(preset.id);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Deleted preset: ${preset.name}'),
              backgroundColor: AppColors.successColor,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete preset: $e'),
              backgroundColor: AppColors.errorColor,
            ),
          );
        }
      }
    }
  }

  void _showPresetEditor({Preset? preset}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => PresetEditor(
        preset: preset,
        onSave: (preset) async {
          try {
            final presetsNotifier = ref.read(presetsNotifierProvider.notifier);
            if (preset.id.isEmpty) {
              // Create new preset
              final newPreset = preset.copyWith(
                id: const Uuid().v4(),
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
              await presetsNotifier.addPreset(newPreset);
            } else {
              // Update existing preset
              final updatedPreset = preset.copyWith(
                updatedAt: DateTime.now(),
              );
              await presetsNotifier.updatePreset(updatedPreset);
            }
            
            if (mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(preset.id.isEmpty ? 'Created preset' : 'Updated preset'),
                  backgroundColor: AppColors.successColor,
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to save preset: $e'),
                  backgroundColor: AppColors.errorColor,
                ),
              );
            }
          }
        },
      ),
    );
  }
}