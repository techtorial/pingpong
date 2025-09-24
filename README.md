# Table Tennis Robot Controller

A polished, cross-platform mobile app that controls a table-tennis robot which throws balls and oscillates left–right. Built with Flutter for iOS and Android.

## Features

### Core Functionality
- **Device Connection**: BLE scanning and connection to table tennis robot
- **Live Control**: Real-time control of robot parameters (frequency, oscillation, topspin, backspin)
- **Power Management**: Safe power on/off with confirmation
- **Emergency Stop**: Immediate motor stop for safety
- **Feed Control**: 3-second countdown before ball feeding starts

### Presets & Drills
- **Preset Management**: Save and load named presets with custom parameters
- **Drill Builder**: Create complex drills with multiple steps and timing
- **Session Tracking**: Monitor training sessions with statistics
- **Data Persistence**: SQLite storage for presets, drills, and session history

### Safety Features
- **Auto-disconnect**: Automatic stop on BLE disconnection
- **Safety Confirmations**: Confirm before power on
- **Emergency Stop**: Always accessible emergency stop button
- **Arm Delay**: 3-second countdown with haptic feedback before feeding

### User Experience
- **Dark/Light Themes**: Automatic theme switching
- **Accessibility**: VoiceOver/TalkBack support
- **Haptic Feedback**: Vibration for important actions
- **Sound Effects**: Audio cues for countdown and alerts
- **One-handed Use**: Optimized for single-hand operation

## Architecture

### Tech Stack
- **Framework**: Flutter 3.10+
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Local Storage**: SQLite
- **BLE Communication**: flutter_reactive_ble
- **Code Generation**: json_serializable, riverpod_generator

### Project Structure
```
lib/
├── core/
│   ├── constants/          # App constants and configuration
│   ├── errors/             # Custom error classes
│   ├── providers/          # Riverpod state providers
│   └── utils/              # Utility functions
├── features/
│   ├── device_connect/     # BLE device scanning and connection
│   ├── live_control/       # Main robot control interface
│   ├── presets/           # Preset management
│   ├── drill_builder/     # Drill creation and editing
│   ├── session/           # Session tracking and monitoring
│   └── settings/          # App configuration
├── models/                # Data models and serialization
├── services/
│   ├── ble/               # BLE communication layer
│   └── storage/           # Data persistence
└── shared/
    ├── theme/             # App theming and styling
    └── widgets/           # Reusable UI components
```

## BLE Communication

### Service UUIDs (Replace with actual values)
```dart
// Robot Control Service
static const String robotServiceUuid = '12345678-1234-1234-1234-123456789ABC';

// Control Characteristics
static const String frequencyCharUuid = '12345678-1234-1234-1234-123456789ABD';
static const String oscillationCharUuid = '12345678-1234-1234-1234-123456789ABE';
static const String topspinCharUuid = '12345678-1234-1234-1234-123456789ABF';
static const String backspinCharUuid = '12345678-1234-1234-1234-123456789AC0';
static const String powerCharUuid = '12345678-1234-1234-1234-123456789AC1';
static const String feedCharUuid = '12345678-1234-1234-1234-123456789AC2';
static const String estopCharUuid = '12345678-1234-1234-1234-123456789AC3';

// Status Characteristics
static const String statusCharUuid = '12345678-1234-1234-1234-123456789AC4';
static const String batteryCharUuid = '12345678-1234-1234-1234-123456789AC5';
```

### Data Format
- **Control Values**: uint8 (0-20 normalized range)
- **Power**: uint8 (0=off, 1=on)
- **Feed**: uint8 (0=stop, 1=start)
- **Emergency Stop**: write 1 to immediately stop all motors
- **Status**: bitmask (feeding, fault, overtemp)
- **Battery**: uint8 (0-100 percentage)

## Setup Instructions

### Prerequisites
- Flutter SDK 3.10.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / Xcode for device testing
- BLE-enabled device for testing

### Installation
1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate code:
   ```bash
   flutter packages pub run build_runner build
   ```

4. Run the app:
   ```bash
   flutter run
   ```

### Mock Mode
The app includes a mock BLE implementation for testing without hardware:
- Simulates device discovery
- Echoes control values
- Simulates connection status
- Provides realistic latency

To switch to real BLE mode, replace the mock implementation in `lib/services/ble/robot_ble_interface.dart`.

## Configuration

### BLE UUIDs
Update the UUIDs in `lib/core/constants/app_constants.dart` with your actual robot's service and characteristic UUIDs.

### Device Name
Configure the expected device name in `AppConstants.deviceNamePrefix`.

### Control Ranges
Adjust the control ranges in `AppConstants`:
- `minValue`: Minimum control value (default: 0)
- `maxValue`: Maximum control value (default: 20)
- `defaultStepSize`: Increment/decrement step size (default: 1)

## Safety Considerations

### Emergency Stop
- Always accessible emergency stop button
- Immediate motor stop (no delay)
- Visual and haptic feedback
- Works even when disconnected

### Auto-disconnect Handling
- Automatic feed stop on BLE disconnection
- User notification of disconnection
- Attempts to reconnect automatically
- Preserves session data

### Power Management
- Confirmation required before power on
- Automatic power off on disconnect
- Visual indicators for power state
- Safe startup sequence

## Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/
```

### Manual Testing Checklist
- [ ] BLE device discovery and connection
- [ ] All control parameters update correctly
- [ ] Emergency stop works immediately
- [ ] Preset save/load functionality
- [ ] Drill creation and execution
- [ ] Session tracking and statistics
- [ ] Dark/light theme switching
- [ ] Accessibility features (VoiceOver/TalkBack)
- [ ] Haptic feedback and sound effects
- [ ] One-handed operation

## Deployment

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:
1. Check the troubleshooting section
2. Search existing issues
3. Create a new issue with detailed information

## Roadmap

### Planned Features
- [ ] QR code sharing for presets and drills
- [ ] Cloud sync for data backup
- [ ] Advanced drill randomization
- [ ] Voice commands
- [ ] Multi-robot support
- [ ] Performance analytics
- [ ] Custom sound effects
- [ ] Widget support for quick access

### Known Issues
- Step editor in drill builder needs implementation
- Export/import functionality pending
- Some accessibility features need refinement
- Mock BLE implementation needs real hardware testing

## Troubleshooting

### Common Issues

#### BLE Connection Problems
- Ensure device is in range
- Check Bluetooth permissions
- Restart Bluetooth on device
- Verify robot is powered on

#### App Crashes
- Check device compatibility
- Ensure all permissions are granted
- Clear app data and restart
- Update to latest version

#### Performance Issues
- Close other apps
- Restart the app
- Check device storage space
- Update device OS

### Debug Mode
Enable debug logging by setting `debugMode = true` in `AppConstants`.

## Changelog

### Version 1.0.0
- Initial release
- Core robot control functionality
- Preset and drill management
- Session tracking
- BLE communication with mock implementation
- Dark/light theme support
- Accessibility features
- Safety mechanisms