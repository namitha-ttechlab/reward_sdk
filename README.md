# reward_sdk

A premium Flutter SDK for implementing reward and loyalty features with beautiful, ready-to-use widgets. 

Bring gamified experiences to your app with high-quality UI components like scratch cards, bottom sheets, and banners.

## Features

- 🎁 **RewardBottomSheet**: Elegant bottom sheet for presenting rewards.
- 📣 **RewardBanner**: Customizable banner for announcements or promotions.
- 🎠 **RewardCarousel**: Smooth carousel for showcasing multiple rewards.
- 📍 **RewardStickyBadge**: Subtle, non-intrusive floating badge.
- 📦 **RewardInlineTile**: Clean inline tile for reward listings.
- 🚪 **RewardExitModal**: Engaging modal shown when users attempt to exit.
- 🎫 **RewardScratchCard**: Interactive scratch card widget for a gamified reveal.

## Getting started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  reward_sdk:
    git:
      url: https://github.com/namitha-ttechlab/reward_sdk.git
```

Or for local development:

```yaml
dependencies:
  reward_sdk:
    path: path/to/reward_sdk
```

Run `flutter pub get` to install.

## Usage

### Using RewardScratchCard

```dart
import 'package:reward_sdk/reward_sdk.dart';

RewardScratchCard(
  title: 'Scratch and Win!',
  subtitle: 'Better luck next time',
  onScratchComplete: () {
    print('Scratch completed!');
  },
)
```

### Using RewardBottomSheet

```dart
import 'package:reward_sdk/reward_sdk.dart';

showModalBottomSheet(
  context: context,
  builder: (context) => RewardBottomSheet(
    title: 'Congratulations!',
    message: 'You unlocked a new reward.',
  ),
);
```

Check the `example` folder for more comprehensive examples.

## Additional information

For documentation, issues, and contributions, please visit the [GitHub repository](https://github.com/namitha-ttechlab/reward_sdk).
