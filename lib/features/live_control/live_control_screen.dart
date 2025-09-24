import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';
import '../../shared/theme/app_theme.dart';
import '../../core/providers/robot_providers.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/control_card.dart';
import '../../shared/widgets/power_toggle.dart';
import '../../shared/widgets/emergency_stop_button.dart';
import '../../shared/widgets/feed_control.dart';

class LiveControlScreen extends ConsumerStatefulWidget {
  const LiveControlScreen({super.key});

  @override
  ConsumerState<LiveControlScreen> createState() => _LiveControlScreenState();
}

class _LiveControlScreenState extends ConsumerState<LiveControlScreen> {
  bool _isArming = false;
  int _countdown = 0;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  void _checkConnection() {
    final isConnected = ref.read(connectionNotifierProvider);
    if (!isConnected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/device-connect');
      });
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _startFeed() async {
    if (_isArming) return;
    
    setState(() {
      _isArming = true;
      _countdown = AppConstants.armDelay.inSeconds;
    });

    // Start countdown
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
      });

      // Vibrate on countdown
      Vibration.vibrate(duration: 100);

      if (_countdown <= 0) {
        timer.cancel();
        _executeFeed();
      }
    });
  }

  Future<void> _executeFeed() async {
    try {
      final robotNotifier = ref.read(robotStateNotifierProvider.notifier);
      await robotNotifier.toggleFeed();
      
      setState(() {
        _isArming = false;
        _countdown = 0;
      });
    } catch (e) {
      setState(() {
        _isArming = false;
        _countdown = 0;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start feeding: $e'),
            backgroundColor: AppColors.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _stopFeed() async {
    _countdownTimer?.cancel();
    setState(() {
      _isArming = false;
      _countdown = 0;
    });

    try {
      final robotNotifier = ref.read(robotStateNotifierProvider.notifier);
      await robotNotifier.toggleFeed();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to stop feeding: $e'),
            backgroundColor: AppColors.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _emergencyStop() async {
    _countdownTimer?.cancel();
    setState(() {
      _isArming = false;
      _countdown = 0;
    });

    try {
      final robotNotifier = ref.read(robotStateNotifierProvider.notifier);
      await robotNotifier.emergencyStop();
      
      // Heavy vibration for emergency stop
      Vibration.vibrate(duration: 500);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('EMERGENCY STOP ACTIVATED'),
            backgroundColor: AppColors.emergencyStop,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Emergency stop failed: $e'),
            backgroundColor: AppColors.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final robotState = ref.watch(robotStateNotifierProvider);
    final isConnected = ref.watch(connectionNotifierProvider);

    if (!isConnected) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Live Control'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/device-connect'),
          ),
        ),
        body: const Center(
          child: Text('Not connected to robot'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Control'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Power Toggle
              PowerToggle(
                isPowered: robotState.isPowered,
                onToggle: () async {
                  final robotNotifier = ref.read(robotStateNotifierProvider.notifier);
                  await robotNotifier.togglePower();
                },
              ),
              
              const SizedBox(height: 24),
              
              // Control Cards
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    ControlCard(
                      title: 'Frequency',
                      value: robotState.frequency,
                      min: AppConstants.minValue,
                      max: AppConstants.maxValue,
                      onChanged: (value) async {
                        final robotNotifier = ref.read(robotStateNotifierProvider.notifier);
                        await robotNotifier.updateFrequency(value);
                      },
                      enabled: robotState.isPowered,
                    ),
                    ControlCard(
                      title: 'Oscillation',
                      value: robotState.oscillation,
                      min: AppConstants.minValue,
                      max: AppConstants.maxValue,
                      onChanged: (value) async {
                        final robotNotifier = ref.read(robotStateNotifierProvider.notifier);
                        await robotNotifier.updateOscillation(value);
                      },
                      enabled: robotState.isPowered,
                    ),
                    ControlCard(
                      title: 'Topspin',
                      value: robotState.topspin,
                      min: AppConstants.minValue,
                      max: AppConstants.maxValue,
                      onChanged: (value) async {
                        final robotNotifier = ref.read(robotStateNotifierProvider.notifier);
                        await robotNotifier.updateTopspin(value);
                      },
                      enabled: robotState.isPowered,
                    ),
                    ControlCard(
                      title: 'Backspin',
                      value: robotState.backspin,
                      min: AppConstants.minValue,
                      max: AppConstants.maxValue,
                      onChanged: (value) async {
                        final robotNotifier = ref.read(robotStateNotifierProvider.notifier);
                        await robotNotifier.updateBackspin(value);
                      },
                      enabled: robotState.isPowered,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Feed Control
              FeedControl(
                isFeeding: robotState.isFeeding,
                isArming: _isArming,
                countdown: _countdown,
                onStart: _startFeed,
                onStop: _stopFeed,
                enabled: robotState.isPowered,
              ),
              
              const SizedBox(height: 16),
              
              // Emergency Stop
              EmergencyStopButton(
                onPressed: _emergencyStop,
              ),
              
              const SizedBox(height: 16),
              
              // Quick Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.go('/presets'),
                      icon: const Icon(Icons.bookmark),
                      label: const Text('Presets'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.go('/drill-builder'),
                      icon: const Icon(Icons.timeline),
                      label: const Text('Drills'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}