# TikTok Clone - Full Stack

A full-stack TikTok clone with Flutter (Android/iOS) and Node.js backend.

## Tech Stack

### Backend
- **Runtime**: Node.js 18+
- **Framework**: Express.js
- **Database**: PostgreSQL
- **Storage**: MinIO (S3-compatible)
- **Authentication**: JWT
- **Deployment**: Railway

### Frontend
- **Framework**: Flutter
- **Platforms**: Android & iOS

## Getting Started

### Prerequisites
- Node.js 18+
- Docker & Docker Compose
- Flutter SDK
- Android Studio (for Android development)

### Local Development with Docker

1. **Clone the repository**
   ```bash
   git clone <your-repo>
   cd tiktok-clone-project
   ```

2. **Start all services**
   ```bash
   docker-compose up -d
   ```

   This will start:
   - PostgreSQL on port 5432
   - MinIO on ports 9000 (API) and 9001 (Console)
   - Backend API on port 3000

3. **Access services**
   - Backend API: http://localhost:3000
   - MinIO Console: http://localhost:9001 (minioadmin / minioadmin123)
   - PostgreSQL: localhost:5432

4. **Check logs**
   ```bash
   docker-compose logs -f backend
   ```

### Manual Backend Setup (without Docker)

1. **Install dependencies**
   ```bash
   cd backend
   npm install
   ```

2. **Configure environment**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

3. **Run the server**
   ```bash
   npm run dev
   ```

### Flutter Setup

1. **Install Flutter**
   - Download from https://flutter.dev/docs/get-started/install

2. **Create Flutter project**
   ```bash
   flutter create tiktok_clone
   cd tiktok_clone
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user

### Users
- `GET /api/users/:username` - Get user profile
- `GET /api/users/:username/posts` - Get user's posts
- `PUT /api/users/profile` - Update profile (authenticated)
- `POST /api/users/:username/follow` - Follow user
- `DELETE /api/users/:username/follow` - Unfollow user

### Posts
- `GET /api/posts/feed` - Get feed
- `GET /api/posts/:postId` - Get single post
- `POST /api/posts` - Create post (authenticated)
- `DELETE /api/posts/:postId` - Delete post (authenticated)
- `POST /api/posts/:postId/like` - Like post
- `DELETE /api/posts/:postId/like` - Unlike post
- `GET /api/posts/:postId/comments` - Get comments
- `POST /api/posts/:postId/comments` - Add comment

### Videos
- `POST /api/videos/upload` - Upload video (authenticated)
- `POST /api/videos/upload-thumbnail` - Upload thumbnail (authenticated)
- `GET /api/videos/:fileName` - Get video URL

## Deployment to Railway

### Backend Deployment

1. **Install Railway CLI**
   ```bash
   npm install -g @railway/cli
   ```

2. **Login to Railway**
   ```bash
   railway login
   ```

3. **Create new project**
   ```bash
   railway init
   ```

4. **Add PostgreSQL**
   ```bash
   railway add postgresql
   ```

5. **Deploy MinIO**
   - Go to Railway dashboard
   - Add new service from Docker image: `minio/minio`
   - Set command: `server /data --console-address ":9001"`
   - Add environment variables:
     - `MINIO_ROOT_USER=minioadmin`
     - `MINIO_ROOT_PASSWORD=minioadmin123`
   - Add volume at `/data`

6. **Deploy Backend**
   ```bash
   cd backend
   railway up
   ```

7. **Set environment variables**
   ```bash
   railway variables set JWT_SECRET=your-secret-key
   railway variables set MINIO_ENDPOINT=your-minio-url
   # ... set other variables
   ```

## Database Schema

### Users Table
- id, username, email, password_hash
- display_name, bio, profile_image_url
- followers_count, following_count, likes_count
- created_at, updated_at

### Posts Table
- id, user_id, video_url, thumbnail_url
- caption, music_name
- likes_count, comments_count, shares_count, views_count
- created_at

### Follows Table
- id, follower_id, following_id, created_at

### Likes Table
- id, user_id, post_id, created_at

### Comments Table
- id, user_id, post_id, comment_text
- likes_count, created_at

## License

MIT
