import 'package:flutter/material.dart';
import '../../models/preset.dart';
import '../theme/app_theme.dart';

class PresetEditor extends StatefulWidget {
  final Preset? preset;
  final ValueChanged<Preset>? onSave;

  const PresetEditor({
    super.key,
    this.preset,
    this.onSave,
  });

  @override
  State<PresetEditor> createState() => _PresetEditorState();
}

class _PresetEditorState extends State<PresetEditor> {
  late TextEditingController _nameController;
  late int _frequency;
  late int _oscillation;
  late int _topspin;
  late int _backspin;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.preset?.name ?? '',
    );
    _frequency = widget.preset?.frequency ?? 0;
    _oscillation = widget.preset?.oscillation ?? 0;
    _topspin = widget.preset?.topspin ?? 0;
    _backspin = widget.preset?.backspin ?? 0;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Text(
                widget.preset == null ? 'Create Preset' : 'Edit Preset',
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
          
          // Name Input
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Preset Name',
              hintText: 'Enter a name for this preset',
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Control Sliders
          Expanded(
            child: Column(
              children: [
                _buildSlider(
                  'Frequency',
                  _frequency,
                  0,
                  20,
                  (value) => setState(() => _frequency = value),
                ),
                _buildSlider(
                  'Oscillation',
                  _oscillation,
                  0,
                  20,
                  (value) => setState(() => _oscillation = value),
                ),
                _buildSlider(
                  'Topspin',
                  _topspin,
                  0,
                  20,
                  (value) {
                    setState(() {
                      _topspin = value;
                      if (value > 0) _backspin = 0;
                    });
                  },
                ),
                _buildSlider(
                  'Backspin',
                  _backspin,
                  0,
                  20,
                  (value) {
                    setState(() {
                      _backspin = value;
                      if (value > 0) _topspin = 0;
                    });
                  },
                ),
              ],
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
                  onPressed: _savePreset,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(
    String label,
    int value,
    int min,
    int max,
    ValueChanged<int> onChanged,
  ) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: theme.textTheme.titleMedium,
              ),
              Text(
                value.toString(),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          Slider(
            value: value.toDouble(),
            min: min.toDouble(),
            max: max.toDouble(),
            divisions: max - min,
            onChanged: (newValue) => onChanged(newValue.round()),
          ),
        ],
      ),
    );
  }

  void _savePreset() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a name for the preset'),
          backgroundColor: AppColors.errorColor,
        ),
      );
      return;
    }

    final preset = Preset(
      id: widget.preset?.id ?? '',
      name: _nameController.text.trim(),
      frequency: _frequency,
      oscillation: _oscillation,
      topspin: _topspin,
      backspin: _backspin,
      createdAt: widget.preset?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    widget.onSave?.call(preset);
  }
}