# 🌍 World Time App

A Flutter application that displays the current time and date in various cities across the world. Users can either select a city manually or let the app detect their device location and show the corresponding time. 

This project demonstrates asynchronous programming, navigation, and API integration in Flutter.

---

## 📱 Features

- ⏰ Display current time and date
- 🧭 Automatically detect user’s location
- 🌐 Select any city manually from the search page
- 📡 Fetches time from WorldTime API
- ✈️ Elegant transition between loading, home, and error pages
- 📦 Uses packages like `location`, `geocoding`, and `flutter_spinkit`

---

## 🛠️ Technologies Used

- **Flutter** 🐦
- **Dart**
- **HTTP API** integration
- `location` package
- `geocoding` package
- `flutter_spinkit` for loading animations

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^0.13.5
  location: ^5.0.3
  geocoding: ^2.1.0
  flutter_spinkit: ^5.1.0
```
---

##🚀 Getting Started

  ###Prerequisites
  
  - Flutter SDK Installed
  - Android Studio or VS Code with flutter plugin
  - Working internet connection

  ###Installation
  ```bash
  git clone https://github.com/HalianCage/WorldTime.git
  cd WorldTime
  flutter pub get
  flutter run
  ```

---
  
##📂 Project Structure
```
lib/
├── main.dart                  # Entry point
├── pages/
│   ├── loading.dart           # Shows loading spinner and fetches time
│   ├── home.dart              # Displays time and location
│   └── search_page.dart       # Allows user to choose a location
├── services/
│   ├── world_time.dart        # Handles API requests to fetch time
│   └── location_services.dart# Handles location permission & coordinates
├── components/
│   └── location_tile.dart     # Custom UI tile for location
```

---

##🧪 Screenshots

###Home Screen

###Loading Screen

###Search Page

---

##🧠 How It Works
- Start App → Goes to loading.dart
- Check arguments from previous page (e.g., city)
- If not provided → Uses location_services.dart to detect user location
- If failed → Falls back to default: San Francisco, USA
- Time is fetched from the API via world_time.dart
- Data passed to home.dart to render UI

---

##❗ Troubleshooting
- If geolocation doesn't work, check:
  - Location permission granted
  - Location services enabled
  - Internet connection is stable

- If time doesn't load for a city:
  - It may not be supported by the API
  - The app will fall back to a default city
 
---

##License & Credits

This project is an adaptation of the original project by NetNinja(hands down the best) in his flutter course - https://www.youtube.com/playlist?list=PL4cUxeGkcC9jLYyp2Aoh6hcWuxFDX6PBJ
There are lots of different adaptations and features that I have added so hope you check it once.
This project is open-source and available under the MIT License.

---

##✨ Author
Made with ❤️ by HalianCage

---
