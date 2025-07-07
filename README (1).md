# ✈️ Flight Search App

A modern and visually appealing Flutter app for searching and viewing available flight options between cities. It includes a smooth search experience, real-time filtering, and beautifully designed flight cards.

![Banner](assets/images/banner1.png)

## 🚀 Features

- 🔍 Search for flights by departure and arrival cities
- 📅 Filter flights by date
- 🧾 Detailed flight info: airline, duration, stops, class, price, and more
- 📱 Mobile-first responsive design
- 💾 Local mock JSON used for flight data (offline testing)

## 📂 Project Structure

```
lib/
├── main.dart
├── features/
│   └── flight_search/
│       ├── presentation/
│       │   ├── search_flights_page.dart
│       │   └── flight_results_page.dart
│       └── provider/
│           └── flight_results_provider.dart
assets/
├── mock_flights.json
└── images/
    ├── banner1.png
    ├── pix1.png
    └── mapp.png
```

## 📦 Dependencies

- `flutter_riverpod` for state management
- `intl` for date formatting
- `flutter` SDK 3.x

## 🧪 Running the App

1. **Install dependencies**:
   ```bash
   flutter pub get
   ```

2. **Run the app**:
   ```bash
   flutter run
   ```

3. **Test the flight search** using mock data (`assets/mock_flights.json`).

## 🧪 Running Tests

To run unit or widget tests:
```bash
flutter test
```

## 📝 Mock Data Format

The app uses a local `mock_flights.json` file structured as follows:

```json
[
  {
    "airline": "Alaska Airlines",
    "from": "Lagos",
    "to": "London",
    "date": "2025-07-10",
    "price": "$320",
    "class": "Economy"
  }
]
```

> Ensure that the dates in `mock_flights.json` match the test dates used in the UI to see results.

## 🧠 Notes

- If no results are shown, verify the `mock_flights.json` file has flights matching your selected route and date.
- You can expand this app to fetch real-time flight data from an external API.

## 🖼 Screenshots

| Search Page | Flight Results |
|-------------|----------------|
| ![Search](assets/images/search_ui.png) | ![Results](assets/images/results_ui.png) |

## 👨‍💻 Author

Built with ❤️ by [Your Name]

## 📄 License

This project is licensed under the MIT License.
