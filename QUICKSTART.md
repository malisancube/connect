# TikTok Clone - Quick Start Guide

## What We've Built

### Backend (Node.js + PostgreSQL + MinIO)
- ✅ REST API with authentication (JWT)
- ✅ User management (register, login, profiles)
- ✅ Post/Video management (create, feed, like, comment)
- ✅ Video upload with MinIO storage
- ✅ Docker Compose setup for local development
- ✅ Ready for Railway deployment

### Frontend (Flutter)
- ✅ Authentication screens (login/register)
- ✅ Video feed with vertical scrolling (TikTok-style)
- ✅ Video playback with controls
- ✅ Like/unlike functionality
- ✅ User profiles
- ✅ State management with Provider
- ✅ Android permissions configured

## Quick Test (Local Development)

### 1. Start the Backend

```bash
cd d:/dev/tiktok-clone-project

# Start all services (PostgreSQL, MinIO, Backend API)
docker-compose up

# Backend will be available at: http://localhost:3000
# MinIO Console: http://localhost:9001 (minioadmin / minioadmin123)
```

**Note:** Make sure Docker Desktop is running first!

### 2. Test the Flutter App

#### Option A: Using Android Emulator

```bash
cd tiktok_clone

# Check for connected devices
C:/flutter/bin/flutter devices

# Run the app
C:/flutter/bin/flutter run
```

#### Option B: Using Physical Android Device

1. Enable Developer Mode on your Android phone
2. Enable USB Debugging
3. Connect via USB
4. Run: `C:/flutter/bin/flutter run`

### 3. Create Test Data

Since this is a fresh install, you'll need to:

1. Register a new user in the app
2. To test the feed, you can either:
   - Upload videos through the app (camera feature needs to be added)
   - Manually insert test data into the database

## Testing the API Manually

```bash
# Register a user
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "password123"
  }'

# Login
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "password": "password123"
  }'

# Get feed
curl http://localhost:3000/api/posts/feed
```

## Deployment to Railway

### 1. Deploy Backend

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login
railway login

# Initialize project
cd backend
railway init

# Add PostgreSQL
railway add postgresql

# Deploy
railway up

# Set environment variables in Railway dashboard
```

### 2. Deploy MinIO

In Railway dashboard:
1. Click "New Service" → "Docker Image"
2. Image: `minio/minio:latest`
3. Add command: `server /data --console-address ":9001"`
4. Add environment variables:
   - `MINIO_ROOT_USER=minioadmin`
   - `MINIO_ROOT_PASSWORD=minioadmin123`
5. Add volume at `/data`
6. Deploy

### 3. Update Flutter App

Update `lib/utils/constants.dart`:
```dart
static const String apiBaseUrl = 'https://your-railway-app.railway.app/api';
```

## Building Android APK

```bash
cd tiktok_clone

# Build APK
C:/flutter/bin/flutter build apk --release

# APK will be at: build/app/outputs/flutter-apk/app-release.apk
```

## Google Play Store Publishing

1. Create Google Play Developer account ($25 one-time fee)
2. Create app listing
3. Build App Bundle (AAB):
   ```bash
   C:/flutter/bin/flutter build appbundle --release
   ```
4. Upload AAB to Play Console
5. Fill out store listing (screenshots, description, etc.)
6. Submit for review

## Project Structure

```
tiktok-clone-project/
├── backend/                    # Node.js API
│   ├── config/                 # DB & MinIO config
│   ├── routes/                 # API endpoints
│   ├── middleware/             # Auth middleware
│   ├── server.js               # Main server
│   ├── Dockerfile              # Docker build
│   └── package.json
│
├── tiktok_clone/               # Flutter app
│   ├── lib/
│   │   ├── models/             # Data models
│   │   ├── providers/          # State management
│   │   ├── screens/            # UI screens
│   │   ├── services/           # API service
│   │   ├── widgets/            # Reusable widgets
│   │   └── main.dart           # App entry point
│   ├── android/                # Android config
│   └── pubspec.yaml            # Dependencies
│
├── docker-compose.yml          # Local dev setup
└── README.md

```

## Next Steps to Complete

1. **Add Camera/Video Recording**
   - Implement camera screen
   - Video trimming
   - Upload to backend

2. **Add More Features**
   - Comments
   - User profiles
   - Following/followers
   - Discover page
   - Notifications

3. **Improve UI**
   - Better loading states
   - Error handling
   - Animations

4. **Testing**
   - Unit tests
   - Widget tests
   - Integration tests

## Troubleshooting

### Backend won't start
- Make sure Docker is running
- Check ports 3000, 5432, 9000, 9001 are not in use
- Run `docker-compose logs backend` to see errors

### Flutter won't compile
- Run `C:/flutter/bin/flutter clean`
- Run `C:/flutter/bin/flutter pub get`
- Check Flutter version: `C:/flutter/bin/flutter doctor`

### Can't connect to backend from Flutter
- Make sure backend is running
- For Android emulator, use `http://10.0.2.2:3000` instead of `localhost:3000`
- For physical device, use your computer's IP address

### Video playback issues
- Make sure video URLs are accessible
- Check CORS settings in backend
- Verify MinIO bucket permissions

## Support

- Backend API: See `backend/routes/` for endpoint details
- Flutter App: See `lib/` for app structure
- Issues: Check GitHub repository issues

---

**Ready to test?** Start with step 1 (Start the Backend) above!
