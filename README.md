<p align="center">
  <img src="https://public.bnbstatic.com/image/cms/blog/20230203/1de9d9fe-ee5d-4f25-a956-c028049a5fea.png" alt="Binance Logo" width="200"/>
</p>

<h1 align="center">📱 Binance App Clone</h1>

<p align="center">
  <strong>A pixel-perfect recreation of the Binance mobile app built with Flutter</strong>
</p>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#screenshots">Screenshots</a> •
  <a href="#tech-stack">Tech Stack</a> •
  <a href="#installation">Installation</a> •
  <a href="#architecture">Architecture</a> •
  <a href="#contributing">Contributing</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"/>
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-green?style=for-the-badge" alt="Platforms"/>
  <img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge" alt="License"/>
</p>

---

## ✨ Overview

This project is a **complete UI clone** of the Binance mobile application, showcasing advanced Flutter development skills including custom animations, complex layouts, interactive widgets, and pixel-perfect design implementation.

> ⚠️ **Disclaimer**: This is a UI demonstration project for educational purposes only. It is not affiliated with, endorsed by, or connected to Binance in any way.

---

## 🎯 Features

### 📊 Trading & Market Data
| Feature | Description |
|---------|-------------|
| **Home Dashboard** | Complete portfolio overview with estimated balance, today's PNL, and quick actions |
| **Live Price Cards** | Real-time styled crypto price cards with mini charts and percentage changes |
| **Candlestick Charts** | Custom painted candlestick charts with MA lines and volume indicators |
| **Order Book** | Real-time styled order book with buy/sell depth visualization |
| **Spot Trading** | Full trading interface with limit/market orders and sliders |

### 📱 Social Features
| Feature | Description |
|---------|-------------|
| **Story Viewer** | Instagram-style stories with progress bars and tap navigation |
| **Feed Posts** | Social feed with like animations, comments, shares, and bookmarks |
| **Live Streams** | Live stream cards with viewer counts and chat indicators |
| **Profile Previews** | Quick profile sheets with follow/unfollow functionality |

### 🔔 Interactive Elements
| Feature | Description |
|---------|-------------|
| **Price Alerts** | Long-press on crypto cards to set price alerts |
| **Search Overlay** | Full search experience with recent searches and trending coins |
| **Balance Toggle** | Hide/show sensitive balance information |
| **Haptic Feedback** | Native haptic responses on all interactions |
| **Pull to Refresh** | Smooth refresh animations across screens |

### 🎨 Design Excellence
| Feature | Description |
|---------|-------------|
| **Binance Brand Colors** | Authentic #F0B90B yellow and dark theme |
| **Custom Painters** | Diamond radar charts, gauge indicators, candlesticks |
| **Smooth Animations** | Carefully crafted micro-interactions throughout |
| **Responsive Layout** | Adapts beautifully to different screen sizes |

---

## 📸 Screenshots

<table>
  <tr>
    <td align="center"><b>🏠 Home Screen</b></td>
    <td align="center"><b>📈 Trading Screen</b></td>
    <td align="center"><b>🪙 Token Detail</b></td>
  </tr>
  <tr>
    <td><img src="screenshots/home.png" width="250"/></td>
    <td><img src="screenshots/trading.png" width="250"/></td>
    <td><img src="screenshots/token_detail.png" width="250"/></td>
  </tr>
  <tr>
    <td align="center"><b>📰 Feed Screen</b></td>
    <td align="center"><b>🎯 Opportunity Screen</b></td>
    <td align="center"><b>💹 Spot Trading</b></td>
  </tr>
  <tr>
    <td><img src="screenshots/feed.png" width="250"/></td>
    <td><img src="screenshots/opportunity.png" width="250"/></td>
    <td><img src="screenshots/spot_trading.png" width="250"/></td>
  </tr>
</table>

---

## 🛠️ Tech Stack

### Core Technologies
```
Flutter 3.x          → Cross-platform UI framework
Dart 3.x             → Programming language
Material Design 3    → Design system
```

### Dependencies
```yaml
dependencies:
  fl_chart: ^0.69.2           # Beautiful charts
  google_fonts: ^6.2.1        # Inter font family
  flutter_svg: ^2.0.17        # SVG support
  cached_network_image: ^3.4.1 # Image caching
  intl: ^0.19.0               # Internationalization
```

### Custom Implementations
- 🎨 **Custom Painters** - Candlestick charts, radar charts, gauge indicators
- 🎭 **Animation Controllers** - Smooth transitions and micro-interactions
- 📐 **Complex Layouts** - Pixel-perfect recreation of Binance UI

---

## 📁 Architecture

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart      # App-wide constants
│   └── theme/
│       └── app_theme.dart          # Binance brand theme
├── features/
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   │       ├── portfolio_card.dart
│   │       ├── crypto_price_card.dart
│   │       ├── search_overlay.dart
│   │       └── bottom_nav_bar.dart
│   ├── trading/
│   │   ├── trading_screen.dart
│   │   └── widgets/
│   │       ├── candlestick_chart.dart
│   │       ├── price_info.dart
│   │       └── trading_bottom_bar.dart
│   ├── token_detail/
│   │   ├── token_detail_screen.dart
│   │   └── widgets/
│   │       ├── ai_rating_chart.dart
│   │       └── ai_recommendation_card.dart
│   ├── feed/
│   │   ├── feed_screen.dart
│   │   └── widgets/
│   │       ├── story_avatar.dart
│   │       ├── feed_post.dart
│   │       └── live_stream_card.dart
│   ├── opportunity/
│   │   ├── opportunity_screen.dart
│   │   └── widgets/
│   │       ├── fear_greed_gauge.dart
│   │       └── market_sentiment_card.dart
│   ├── spot_trading/
│   │   └── spot_trading_screen.dart
│   ├── splash/
│   │   └── splash_screen.dart
│   └── onboarding/
│       └── onboarding_screen.dart
├── shared/
│   └── widgets/
│       ├── crypto_icon.dart
│       └── mini_line_chart.dart
└── main.dart
```

---

## 🚀 Installation

### Prerequisites
- Flutter SDK 3.x or higher
- Dart SDK 3.x or higher
- Android Studio / VS Code
- Android Emulator or iOS Simulator

### Setup

1. **Clone the repository**
```bash
git clone https://github.com/davidcreated/Binance-.git
cd Binance-
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
# For development
flutter run

# For specific platform
flutter run -d android
flutter run -d ios
flutter run -d chrome
```

4. **Build for production**
```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

---

## 🎮 Usage Guide

### Navigation
| Action | Description |
|--------|-------------|
| **Bottom Nav** | Switch between Home, Markets, Trade, Futures, Wallets |
| **Tap Crypto Card** | Navigate to token detail screen |
| **Tap Search Bar** | Open search overlay with trending coins |

### Interactions
| Action | Description |
|--------|-------------|
| **Long Press Crypto** | Set price alert |
| **Double Tap Post** | Like with heart animation |
| **Tap Story Avatar** | Open story viewer |
| **Tap Eye Icon** | Toggle balance visibility |
| **Tap Refresh** | Refresh portfolio data |

### Gestures
| Gesture | Description |
|---------|-------------|
| **Tap Left/Right** | Navigate stories |
| **Pull Down** | Refresh feed |
| **Swipe** | Navigate between tabs |

---

## 🎨 Design System

### Brand Colors
```dart
Primary Yellow    → #F0B90B
Dark Background   → #181A20
Card Background   → #1E2026
Success Green     → #0ECB81
Error Red         → #F6465D
```

### Typography
```dart
Font Family: Inter (Google Fonts)
Weights: 400 (Regular), 500 (Medium), 600 (SemiBold), 700 (Bold)
```

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Areas for Contribution
- [ ] Add more screens (Futures, P2P, etc.)
- [ ] Implement real API integration
- [ ] Add unit and widget tests
- [ ] Improve accessibility
- [ ] Add localization support

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **Binance** - For the beautiful app design inspiration
- **Flutter Team** - For the amazing framework
- **Community** - For open-source packages used in this project

---

## 📬 Contact

**David** - [@davidcreated](https://github.com/davidcreated)

Project Link: [https://github.com/davidcreated/Binance-](https://github.com/davidcreated/Binance-)

---

<p align="center">
  <b>⭐ If you found this project helpful, please give it a star! ⭐</b>
</p>

<p align="center">
  Made with ❤️ and Flutter
</p>
