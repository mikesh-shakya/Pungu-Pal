# Pungu Pal 🥗

A lightweight iOS calories tracker app built with SwiftUI and CoreData. Start tracking your nutrition habits with ease!

## Vision

Pungu Pal is inspired by MyFitnessPal but designed to be simple, fast, and focused. Eventually scale to include comprehensive nutrition tracking, exercise logging, and social features.

## Current Features (MVP)

- ✅ Log daily food intake
- ✅ Track daily calorie consumption
- ✅ Set daily calorie goals
- ✅ View daily summary and progress
- ✅ Track history of logs

## Planned Features

- 🔄 Barcode scanning for food items
- 🔄 Nutrition macros tracking (protein, carbs, fats)
- 🔄 Exercise logging and calorie burn tracking
- 🔄 Weekly/monthly reports and insights
- 🔄 Custom meal templates
- 🔄 Social features (friend comparison, challenges)

## Tech Stack

- **UI Framework:** SwiftUI
- **Data Persistence:** CoreData
- **Architecture:** MVVM
- **Deployment Target:** iOS 15.0+
- **Language:** Swift

## Project Structure

```
Pungu-Pal/
├── PunguPal/
│   ├── App/
│   │   └── PunguPalApp.swift
│   ├── Models/
│   │   ├── Food.swift
│   │   ├── FoodLog.swift
│   │   └── User.swift
│   ├── ViewModels/
│   │   ├── HomeViewModel.swift
│   │   ├── LogFoodViewModel.swift
│   │   └── SettingsViewModel.swift
│   ├── Views/
│   │   ├── ContentView.swift
│   │   ├── HomeView.swift
│   │   ├── LogFoodView.swift
│   │   ├── HistoryView.swift
│   │   └── SettingsView.swift
│   ├── Services/
│   │   ├── CoreDataManager.swift
│   │   └── FoodService.swift
│   └── Utilities/
│       └── Constants.swift
├── PunguPal.xcodeproj/
└── README.md
```

## Getting Started

### Prerequisites
- Xcode 13+
- iOS 15.0+

### Installation

1. Clone the repository:
```bash
git clone https://github.com/mikesh-shakya/Pungu-Pal.git
cd Pungu-Pal
```

2. Open the project:
```bash
open PunguPal.xcodeproj
```

3. Build and run on simulator or device:
```bash
⌘ + R
```

## Development

### Creating New Features
1. Create models in `Models/`
2. Create corresponding ViewModels in `ViewModels/`
3. Create UI in `Views/`
4. Wire them together in the appropriate views

### CoreData
- Managed through `CoreDataManager` service
- Models follow MVVM pattern

## Contributing

This is a personal project, but feel free to fork and adapt for your own use!

## License

MIT

## Roadmap

- [ ] v0.1 - Basic food logging and calorie tracking
- [ ] v0.2 - Nutrition macros display
- [ ] v0.3 - Exercise tracking
- [ ] v0.4 - Weekly reports
- [ ] v0.5 - Social features

---

Happy tracking with **Pungu Pal**! 🎯