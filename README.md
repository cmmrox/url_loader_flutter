# URL Loader Flutter

A Flutter application that provides a web app viewer with enhanced features for viewing web content.

## Features

- Web content viewing with full JavaScript support
- Offline mode detection and handling
- Screen wake lock to prevent screen timeout
- Loading indicators for better user experience
- Responsive design that works across multiple platforms
- Error handling and retry functionality
- Immersive UI mode for distraction-free viewing

## Getting Started

### Prerequisites

- Flutter SDK (>=3.2.3)
- Dart SDK (>=3.2.3)
- Android Studio / VS Code with Flutter extensions
- Git

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/url_loader_flutter.git
```

2. Navigate to the project directory:
```bash
cd url_loader_flutter
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the application:
```bash
flutter run
```

## Dependencies

- webview_flutter: ^4.7.0
- connectivity_plus: ^5.0.2
- wakelock_plus: ^1.1.4

## Platform Support

- Android
- iOS
- Web
- Windows
- Linux
- macOS

## Configuration

The application uses a base URL configuration that can be modified in `lib/core/constants/app_constants.dart`.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
