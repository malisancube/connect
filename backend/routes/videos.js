const express = require('express');
const router = express.Router();
const multer = require('multer');
const { v4: uuidv4 } = require('uuid');
const { minioClient, bucketName } = require('../config/minio');
const { authenticateToken } = require('../middleware/auth');

// Configure multer for memory storage
const upload = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: 100 * 1024 * 1024 // 100MB max file size
  },
  fileFilter: (req, file, cb) => {
    // Accept video files only
    if (file.mimetype.startsWith('video/')) {
      cb(null, true);
    } else {
      cb(new Error('Only video files are allowed'), false);
    }
  }
});

// Upload video
router.post('/upload', authenticateToken, upload.single('video'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'No video file provided' });
    }

    const fileExtension = req.file.originalname.split('.').pop();
    const fileName = `${uuidv4()}.${fileExtension}`;
    const filePath = `videos/${fileName}`;

    // Upload to MinIO
    await minioClient.putObject(
      bucketName,
      filePath,
      req.file.buffer,
      req.file.size,
      {
        'Content-Type': req.file.mimetype
      }
    );

    // Generate presigned URL (valid for 7 days)
    const videoUrl = await minioClient.presignedGetObject(
      bucketName,
      filePath,
      7 * 24 * 60 * 60
    );

    res.json({
      videoUrl: videoUrl.split('?')[0], // Return URL without query params for consistency
      fileName: filePath
    });
  } catch (error) {
    console.error('Video upload error:', error);
    res.status(500).json({ error: 'Failed to upload video' });
  }
});

// Upload thumbnail
router.post('/upload-thumbnail', authenticateToken, upload.single('thumbnail'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'No thumbnail file provided' });
    }

    const fileExtension = req.file.originalname.split('.').pop();
    const fileName = `${uuidv4()}.${fileExtension}`;
    const filePath = `thumbnails/${fileName}`;

    // Upload to MinIO
    await minioClient.putObject(
      bucketName,
      filePath,
      req.file.buffer,
      req.file.size,
      {
        'Content-Type': req.file.mimetype
      }
    );

    // Generate presigned URL
    const thumbnailUrl = await minioClient.presignedGetObject(
      bucketName,
      filePath,
      7 * 24 * 60 * 60
    );

    res.json({
      thumbnailUrl: thumbnailUrl.split('?')[0],
      fileName: filePath
    });
  } catch (error) {
    console.error('Thumbnail upload error:', error);
    res.status(500).json({ error: 'Failed to upload thumbnail' });
  }
});

// Get video URL
router.get('/:fileName', async (req, res) => {
  try {
    const { fileName } = req.params;

    // Generate presigned URL
    const url = await minioClient.presignedGetObject(
      bucketName,
      fileName,
      24 * 60 * 60 // 24 hours
    );

    res.json({ url });
  } catch (error) {
    console.error('Get video URL error:', error);
    res.status(500).json({ error: 'Failed to get video URL' });
  }
});

module.exports = router;
