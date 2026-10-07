# 🚀 MKrypto

### Cryptocurrency Market Research App

MKrypto is a Flutter-based cryptocurrency market research application developed as part of a Flutter Developer technical assignment.

The application allows users to explore cryptocurrency markets, view detailed coin information, analyze price charts, view global market statistics, and manage a personal watchlist.

---

## 📱 Screenshots

### Market

![Market Screen](screenshots/market.png)

### Market Statistics

![Market Statistics](screenshots/statistics.png)

### Watchlist

![Watchlist](screenshots/watchlist.png)

### Coin Details

![Coin Details](screenshots/coin-details.png)

---

## ✨ Features

### 📊 Market

- Cryptocurrency market listing
- Search cryptocurrencies by name or symbol
- Filter by All, Gainers, and Losers
- Sort by market capitalization
- Current price and 24-hour price change
- Market capitalization
- Trading volume
- Pull-to-refresh market data

### 📈 Coin Details

- Current cryptocurrency price
- 24-hour price change
- Market capitalization
- Trading volume
- Circulating supply
- Total supply
- Maximum supply
- Market-cap rank
- All-Time High (ATH)
- All-Time Low (ATL)
- Interactive price chart
- 1H / 1D / 7D / 30D / 1Y chart ranges
- Share coin information

### 🌎 Market Statistics

- Total cryptocurrency market capitalization
- 24-hour market volume
- Market-cap change
- Bitcoin dominance
- Ethereum dominance
- Top Gainers
- Top Losers

### ⭐ Watchlist

- Add cryptocurrencies to watchlist
- Remove cryptocurrencies from watchlist
- Open saved coin details

---

## 🏗️ Architecture

```text
┌──────────────┐     ┌──────────────┐     ┌────────────────┐     ┌──────────────────┐     ┌──────────────┐
│ Flutter App  │ ──► │   Provider   │ ──► │ ApiService/Dio │ ──► │ Render Backend   │ ──► │  CoinGecko   │
│ Views/Widgets│     │ State & Logic│     │  REST Client   │     │ Node.js/Express  │     │     API      │
└──────────────┘     └──────────────┘     └────────────────┘     └──────────────────┘     └──────────────┘
```

### API Flow

```text
Flutter App  ──►  Render Backend  ──►  CoinGecko API
                 Node.js + Express
```

The Flutter application communicates with the Node.js and Express backend deployed on Render.

The backend communicates with CoinGecko to retrieve cryptocurrency market data.

The CoinGecko API key is stored securely as a Render environment variable and is not included in the Flutter application or GitHub repository.

---

## 🛠️ Technology Stack

### Frontend

- Flutter
- Dart
- Provider
- Dio
- FL Chart
- Cached Network Image
- Share Plus

### Backend

- Node.js
- Express.js
- Axios
- CORS
- dotenv

### Data Provider

- CoinGecko API

### Deployment

- Render

---

## 🌐 Production Backend

The Flutter application uses a Node.js and Express.js backend deployed on Render.

### Production Backend

https://mkrypto-backend.onrender.com

### API Base URL

https://mkrypto-backend.onrender.com/api

### API Endpoints

```text
GET /api/coins
GET /api/coins/:id
GET /api/coins/:id/chart
GET /api/market
```

### Production Request Flow

```text
Flutter App  ──►  Render Backend  ──►  CoinGecko API
```

The backend acts as the API layer between the Flutter application and CoinGecko.

The CoinGecko API key is stored on the Render server as an environment variable and is not exposed in the Flutter application.

---

## ▶️ Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/Mmk-Mane/MKrypto.git
cd MKrypto/mkrypto
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

### 3. Run the Application

```bash
flutter run
```

The Flutter application is already configured to use the production backend deployed on Render.

### Production Backend

```text
https://mkrypto-backend.onrender.com
```

No local Node.js backend setup or CoinGecko API key is required to run the Flutter application.

### Build Release APK

```bash
flutter build apk --release
```

### Flutter

```bash
cd mkrypto
flutter pub get
flutter run
```

### Build Release APK

```bash
flutter build apk --release
```

---

## 📱 Testing

The release APK was tested on multiple physical Android devices using the production Render backend.

The following functionality was tested:

- Market data loading
- Search
- All / Gainers / Losers filters
- Market-cap sorting
- Pull-to-refresh
- Global market statistics
- Top Gainers and Top Losers
- Coin details
- Interactive price charts
- Watchlist
- Production API connectivity

---

## 📂 Project Structure

```text
MKrypto/
│
├── backend/
│   ├── src/
│   │   ├── routes/
│   │   └── services/
│   ├── server.js
│   ├── package.json
│   └── .env.example
│
└── mkrypto/
    ├── lib/
    │   ├── models/
    │   ├── providers/
    │   ├── services/
    │   ├── views/
    │   │   ├── details/
    │   │   ├── home/
    │   │   ├── market/
    │   │   ├── statistics/
    │   │   └── watchlist/
    │   └── widgets/
    ├── android/
    ├── ios/
    └── pubspec.yaml
```

---

## 👨‍💻 Developer

### Manikandan

**Flutter Developer**

Built with Flutter, Dart, Node.js, Express.js, and CoinGecko API.
