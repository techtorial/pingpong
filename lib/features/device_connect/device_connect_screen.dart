import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import '../../shared/theme/app_theme.dart';
import '../../core/providers/robot_providers.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/device_card.dart';
import '../../shared/widgets/connection_status.dart';

class DeviceConnectScreen extends ConsumerStatefulWidget {
  const DeviceConnectScreen({super.key});

  @override
  ConsumerState<DeviceConnectScreen> createState() => _DeviceConnectScreenState();
}

class _DeviceConnectScreenState extends ConsumerState<DeviceConnectScreen> {
  bool _isScanning = false;
  List<DiscoveredDevice> _discoveredDevices = [];
  String? _selectedDeviceId;

  @override
  void initState() {
    super.initState();
    _initializeBle();
  }

  Future<void> _initializeBle() async {
    final bleService = ref.read(robotBleServiceProvider);
    await bleService.initialize();
  }

  Future<void> _startScanning() async {
    setState(() {
      _isScanning = true;
      _discoveredDevices.clear();
    });

    try {
      final bleService = ref.read(robotBleServiceProvider);
      await bleService.startScanning();
      
      // Listen to discovered devices
      bleService.discoveredDevices.then((devices) {
        if (mounted) {
          setState(() {
            _discoveredDevices = devices;
          });
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start scanning: $e'),
            backgroundColor: AppColors.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _stopScanning() async {
    setState(() {
      _isScanning = false;
    });

    try {
      final bleService = ref.read(robotBleServiceProvider);
      await bleService.stopScanning();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to stop scanning: $e'),
            backgroundColor: AppColors.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _connectToDevice(String deviceId) async {
    try {
      final connectionNotifier = ref.read(connectionNotifierProvider.notifier);
      await connectionNotifier.connectToDevice(deviceId);
      
      if (mounted) {
        context.go('/live-control');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to connect: $e'),
            backgroundColor: AppColors.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = ref.watch(connectionNotifierProvider);
    final robotState = ref.watch(robotStateNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect to Robot'),
        actions: [
          if (isConnected)
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Connection Status
              ConnectionStatus(
                isConnected: isConnected,
                robotState: robotState,
              ),
              
              const SizedBox(height: 24),
              
              // Scan Button
              ElevatedButton.icon(
                onPressed: _isScanning ? _stopScanning : _startScanning,
                icon: Icon(_isScanning ? Icons.stop : Icons.search),
                label: Text(_isScanning ? 'Stop Scanning' : 'Scan for Devices'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Device List
              Expanded(
                child: _buildDeviceList(),
              ),
              
              // Quick Actions
              if (isConnected) ...[
                const SizedBox(height: 16),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceList() {
    if (_discoveredDevices.isEmpty && !_isScanning) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bluetooth_searching,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No devices found',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Make sure your robot is powered on and in range',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_isScanning && _discoveredDevices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Scanning for devices...',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _discoveredDevices.length,
      itemBuilder: (context, index) {
        final device = _discoveredDevices[index];
        final isSelected = _selectedDeviceId == device.id;
        
        return DeviceCard(
          device: device,
          isSelected: isSelected,
          onTap: () {
            setState(() {
              _selectedDeviceId = device.id;
            });
          },
          onConnect: () => _connectToDevice(device.id),
        );
      },
    );
  }
}