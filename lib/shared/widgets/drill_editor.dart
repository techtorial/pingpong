import 'package:flutter/material.dart';
import '../../models/drill.dart';
import '../../models/drill_step.dart';
import '../theme/app_theme.dart';

class DrillEditor extends StatefulWidget {
  final Drill? drill;
  final ValueChanged<Drill>? onSave;

  const DrillEditor({
    super.key,
    this.drill,
    this.onSave,
  });

  @override
  State<DrillEditor> createState() => _DrillEditorState();
}

class _DrillEditorState extends State<DrillEditor> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late int _loops;
  late List<DrillStep> _steps;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.drill?.name ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.drill?.description ?? '',
    );
    _loops = widget.drill?.loops ?? 1;
    _steps = List.from(widget.drill?.steps ?? []);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Text(
                widget.drill == null ? 'Create Drill' : 'Edit Drill',
                style: theme.textTheme.titleLarge,
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Name and Description
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Drill Name',
              hintText: 'Enter a name for this drill',
            ),
          ),
          
          const SizedBox(height: 16),
          
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description (Optional)',
              hintText: 'Enter a description for this drill',
            ),
            maxLines: 2,
          ),
          
          const SizedBox(height: 16),
          
          // Loops
          Row(
            children: [
              Text(
                'Loops: ',
                style: theme.textTheme.titleMedium,
              ),
              Expanded(
                child: Slider(
                  value: _loops.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  onChanged: (value) => setState(() => _loops = value.round()),
                ),
              ),
              Text(
                _loops.toString(),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Steps Header
          Row(
            children: [
              Text(
                'Steps (${_steps.length})',
                style: theme.textTheme.titleMedium,
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _addStep,
                icon: const Icon(Icons.add),
                label: const Text('Add Step'),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Steps List
          Expanded(
            child: _steps.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timeline_outlined,
                          size: 64,
                          color: theme.colorScheme.primary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No steps yet',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add steps to create your drill',
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _steps.length,
                    itemBuilder: (context, index) {
                      final step = _steps[index];
                      return _buildStepCard(step, index);
                    },
                  ),
          ),
          
          const SizedBox(height: 24),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveDrill,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard(DrillStep step, int index) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Step ${index + 1}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _removeStep(index),
                  icon: const Icon(Icons.delete, color: AppColors.errorColor),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Step Values
            Row(
              children: [
                _buildStepValue('Duration', '${step.durationSec}s'),
                const SizedBox(width: 8),
                _buildStepValue('Freq', step.frequency.toString()),
                const SizedBox(width: 8),
                _buildStepValue('Osc', step.oscillation.toString()),
                const SizedBox(width: 8),
                _buildStepValue('Top', step.topspin.toString()),
                const SizedBox(width: 8),
                _buildStepValue('Back', step.backspin.toString()),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Edit Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _editStep(index),
                child: const Text('Edit Step'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepValue(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$label: $value',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _addStep() {
    final newStep = DrillStep(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      durationSec: 30,
      frequency: 10,
      oscillation: 5,
      topspin: 0,
      backspin: 0,
    );
    
    setState(() {
      _steps.add(newStep);
    });
  }

  void _removeStep(int index) {
    setState(() {
      _steps.removeAt(index);
    });
  }

  void _editStep(int index) {
    // TODO: Implement step editor
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Step editor not implemented yet'),
        backgroundColor: AppColors.warningColor,
      ),
    );
  }

  void _saveDrill() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a name for the drill'),
          backgroundColor: AppColors.errorColor,
        ),
      );
      return;
    }

    if (_steps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one step'),
          backgroundColor: AppColors.errorColor,
        ),
      );
      return;
    }

    final drill = Drill(
      id: widget.drill?.id ?? '',
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty 
          ? null 
          : _descriptionController.text.trim(),
      loops: _loops,
      steps: _steps,
      createdAt: widget.drill?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    widget.onSave?.call(drill);
  }
}