import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../shared/theme/app_theme.dart';
import '../../core/providers/robot_providers.dart';
import '../../models/drill.dart';
import '../../models/drill_step.dart';
import '../../shared/widgets/drill_card.dart';
import '../../shared/widgets/drill_editor.dart';

class DrillBuilderScreen extends ConsumerStatefulWidget {
  const DrillBuilderScreen({super.key});

  @override
  ConsumerState<DrillBuilderScreen> createState() => _DrillBuilderScreenState();
}

class _DrillBuilderScreenState extends ConsumerState<DrillBuilderScreen> {
  @override
  Widget build(BuildContext context) {
    final drillsAsync = ref.watch(drillsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Drill Builder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showDrillEditor(),
          ),
        ],
      ),
      body: SafeArea(
        child: drillsAsync.when(
          data: (drills) => _buildDrillsList(drills),
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
                  'Failed to load drills',
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
                  onPressed: () => ref.invalidate(drillsNotifierProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrillsList(List<Drill> drills) {
    if (drills.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timeline_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No drills yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first drill to get started',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showDrillEditor(),
              icon: const Icon(Icons.add),
              label: const Text('Create Drill'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: drills.length,
      itemBuilder: (context, index) {
        final drill = drills[index];
        return DrillCard(
          drill: drill,
          onTap: () => _showDrillEditor(drill: drill),
          onDelete: () => _deleteDrill(drill),
          onRun: () => _runDrill(drill),
        );
      },
    );
  }

  Future<void> _runDrill(Drill drill) async {
    // Navigate to session screen with drill
    context.go('/session', extra: drill);
  }

  Future<void> _deleteDrill(Drill drill) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Drill'),
        content: Text('Are you sure you want to delete "${drill.name}"?'),
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
        final drillsNotifier = ref.read(drillsNotifierProvider.notifier);
        await drillsNotifier.deleteDrill(drill.id);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Deleted drill: ${drill.name}'),
              backgroundColor: AppColors.successColor,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete drill: $e'),
              backgroundColor: AppColors.errorColor,
            ),
          );
        }
      }
    }
  }

  void _showDrillEditor({Drill? drill}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DrillEditor(
        drill: drill,
        onSave: (drill) async {
          try {
            final drillsNotifier = ref.read(drillsNotifierProvider.notifier);
            if (drill.id.isEmpty) {
              // Create new drill
              final newDrill = drill.copyWith(
                id: const Uuid().v4(),
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
              await drillsNotifier.addDrill(newDrill);
            } else {
              // Update existing drill
              final updatedDrill = drill.copyWith(
                updatedAt: DateTime.now(),
              );
              await drillsNotifier.updateDrill(updatedDrill);
            }
            
            if (mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(drill.id.isEmpty ? 'Created drill' : 'Updated drill'),
                  backgroundColor: AppColors.successColor,
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to save drill: $e'),
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