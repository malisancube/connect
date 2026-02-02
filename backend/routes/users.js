const express = require('express');
const router = express.Router();
const { pool } = require('../config/database');
const { authenticateToken } = require('../middleware/auth');

// Get user profile
router.get('/:username', async (req, res) => {
  try {
    const { username } = req.params;

    const result = await pool.query(
      `SELECT id, username, display_name, bio, profile_image_url,
              followers_count, following_count, likes_count, created_at
       FROM users WHERE username = $1`,
      [username]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error('Get user error:', error);
    res.status(500).json({ error: 'Failed to get user' });
  }
});

// Get user's posts
router.get('/:username/posts', async (req, res) => {
  try {
    const { username } = req.params;
    const { limit = 20, offset = 0 } = req.query;

    const result = await pool.query(
      `SELECT p.*, u.username, u.display_name, u.profile_image_url
       FROM posts p
       JOIN users u ON p.user_id = u.id
       WHERE u.username = $1
       ORDER BY p.created_at DESC
       LIMIT $2 OFFSET $3`,
      [username, limit, offset]
    );

    res.json(result.rows);
  } catch (error) {
    console.error('Get user posts error:', error);
    res.status(500).json({ error: 'Failed to get posts' });
  }
});

// Update profile (authenticated)
router.put('/profile', authenticateToken, async (req, res) => {
  try {
    const { displayName, bio, profileImageUrl } = req.body;
    const userId = req.user.userId;

    const result = await pool.query(
      `UPDATE users
       SET display_name = COALESCE($1, display_name),
           bio = COALESCE($2, bio),
           profile_image_url = COALESCE($3, profile_image_url),
           updated_at = CURRENT_TIMESTAMP
       WHERE id = $4
       RETURNING id, username, display_name, bio, profile_image_url`,
      [displayName, bio, profileImageUrl, userId]
    );

    res.json(result.rows[0]);
  } catch (error) {
    console.error('Update profile error:', error);
    res.status(500).json({ error: 'Failed to update profile' });
  }
});

// Follow user
router.post('/:username/follow', authenticateToken, async (req, res) => {
  try {
    const { username } = req.params;
    const followerId = req.user.userId;

    // Get user to follow
    const userResult = await pool.query(
      'SELECT id FROM users WHERE username = $1',
      [username]
    );

    if (userResult.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    const followingId = userResult.rows[0].id;

    if (followerId === followingId) {
      return res.status(400).json({ error: 'Cannot follow yourself' });
    }

    // Insert follow relationship
    await pool.query(
      'INSERT INTO follows (follower_id, following_id) VALUES ($1, $2) ON CONFLICT DO NOTHING',
      [followerId, followingId]
    );

    // Update counts
    await pool.query(
      'UPDATE users SET followers_count = followers_count + 1 WHERE id = $1',
      [followingId]
    );
    await pool.query(
      'UPDATE users SET following_count = following_count + 1 WHERE id = $1',
      [followerId]
    );

    res.json({ message: 'Followed successfully' });
  } catch (error) {
    console.error('Follow error:', error);
    res.status(500).json({ error: 'Failed to follow user' });
  }
});

// Unfollow user
router.delete('/:username/follow', authenticateToken, async (req, res) => {
  try {
    const { username } = req.params;
    const followerId = req.user.userId;

    // Get user to unfollow
    const userResult = await pool.query(
      'SELECT id FROM users WHERE username = $1',
      [username]
    );

    if (userResult.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    const followingId = userResult.rows[0].id;

    // Delete follow relationship
    const result = await pool.query(
      'DELETE FROM follows WHERE follower_id = $1 AND following_id = $2',
      [followerId, followingId]
    );

    if (result.rowCount > 0) {
      // Update counts
      await pool.query(
        'UPDATE users SET followers_count = followers_count - 1 WHERE id = $1',
        [followingId]
      );
      await pool.query(
        'UPDATE users SET following_count = following_count - 1 WHERE id = $1',
        [followerId]
      );
    }

    res.json({ message: 'Unfollowed successfully' });
  } catch (error) {
    console.error('Unfollow error:', error);
    res.status(500).json({ error: 'Failed to unfollow user' });
  }
});

module.exports = router;
