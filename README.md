# EduPlay - Interactive Educational App

EduPlay is an engaging Flutter application designed to make learning fun and interactive for children. The app combines gaming elements with educational content to create an immersive learning experience.

## Features

### Core Activities
- **Audio Recognition Activities**
  - Interactive audio player with play/pause controls
  - Multiple choice questions
  - Immediate feedback on answers
  - Clear question navigation
  - Progress tracking
  
- **Sentence Activities**
  - Practice sentence construction
  - Drag and drop word ordering
  - Progressive difficulty levels
  - Visual feedback for correct ordering

## Getting Started

### Prerequisites
- Flutter (2.5.0 or higher)
- Dart SDK (2.14.0 or higher)
- Android Studio / VS Code with Flutter extension

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── models/         # Data models
├── screens/        # Activity screens
│   └── activities/ # Different activity types
├── services/       # Business logic
├── utils/         # Helper functions
└── widgets/       # Reusable UI components
```

## Development Guidelines

### Adding New Activities
1. Create a new screen in `lib/screens/activities/`
2. Add the activity type in `lib/models/activity.dart`
3. Update `ContentService` with new activity data
4. Add navigation in the main activity list

### Coding Style
- Follow Flutter's style guide
- Use meaningful variable and function names
- Comment complex logic
- Maintain widget composition for reusability

## Testing
Run tests using:
```bash
flutter test
```



## License
This project is licensed under the MIT License
