import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../../shared/theme/app_theme.dart';
import '../../core/providers/robot_providers.dart';
import '../../models/drill.dart';
import '../../models/session.dart';
import '../../shared/widgets/session_timer.dart';
import '../../shared/widgets/session_stats.dart';
import '../../shared/widgets/drill_progress.dart';

class SessionScreen extends ConsumerStatefulWidget {
  final Drill? drill;
  
  const SessionScreen({
    super.key,
    this.drill,
  });

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen> {
  Timer? _sessionTimer;
  Timer? _ballsTimer;
  int _ballsThrown = 0;
  bool _isSessionActive = false;

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _ballsTimer?.cancel();
    super.dispose();
  }

  void _startSession() {
    final sessionNotifier = ref.read(sessionNotifierProvider.notifier);
    sessionNotifier.startSession(
      drillId: widget.drill?.id,
      drillName: widget.drill?.name,
    );
    
    setState(() {
      _isSessionActive = true;
    });
    
    // Start session timer
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Update session duration
    });
    
    // Start balls timer (simulate ball throwing)
    _ballsTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _ballsThrown++;
      });
      
      final sessionNotifier = ref.read(sessionNotifierProvider.notifier);
      sessionNotifier.updateBallsThrown(_ballsThrown);
    });
  }

  void _endSession() {
    _sessionTimer?.cancel();
    _ballsTimer?.cancel();
    
    final sessionNotifier = ref.read(sessionNotifierProvider.notifier);
    sessionNotifier.endSession();
    
    setState(() {
      _isSessionActive = false;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Session ended'),
          backgroundColor: AppColors.successColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionNotifierProvider);
    final robotState = ref.watch(robotStateNotifierProvider);
    
    if (session == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Session'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/live-control'),
          ),
        ),
        body: const Center(
          child: Text('No active session'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/live-control'),
        ),
        actions: [
          if (_isSessionActive)
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: _endSession,
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Session Timer
              SessionTimer(
                startTime: session.startTime,
                isActive: _isSessionActive,
              ),
              
              const SizedBox(height: 24),
              
              // Session Stats
              SessionStats(
                ballsThrown: _ballsThrown,
                isFeeding: robotState.isFeeding,
                drillName: session.drillName,
              ),
              
              const SizedBox(height: 24),
              
              // Drill Progress (if running a drill)
              if (widget.drill != null) ...[
                DrillProgress(
                  drill: widget.drill!,
                  currentStep: 0, // TODO: Calculate current step
                  totalSteps: widget.drill!.steps.length,
                ),
                const SizedBox(height: 24),
              ],
              
              // Quick Controls
              Expanded(
                child: Column(
                  children: [
                  // Robot Status
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                robotState.isFeeding ? Icons.play_arrow : Icons.pause,
                                color: robotState.isFeeding ? AppColors.feeding : AppColors.disconnected,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                robotState.isFeeding ? 'FEEDING' : 'STOPPED',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: robotState.isFeeding ? AppColors.feeding : AppColors.disconnected,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 12),
                          
                          Row(
                            children: [
                              _buildStatusChip('Freq', robotState.frequency),
                              const SizedBox(width: 8),
                              _buildStatusChip('Osc', robotState.oscillation),
                              const SizedBox(width: 8),
                              _buildStatusChip('Top', robotState.topspin),
                              const SizedBox(width: 8),
                              _buildStatusChip('Back', robotState.backspin),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => context.go('/live-control'),
                          icon: const Icon(Icons.settings),
                          label: const Text('Controls'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => context.go('/presets'),
                          icon: const Icon(Icons.bookmark),
                          label: const Text('Presets'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, int value) {
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
}