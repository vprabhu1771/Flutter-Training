Here's the Node.js backend logic to handle the image upload from your Flutter app:

## **1. Server Setup (server.js)**

```javascript
const express = require('express');
const multer = require('multer');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Ensure uploads directory exists
const uploadDir = './uploads';
if (!fs.existsSync(uploadDir)) {
    fs.mkdirSync(uploadDir, { recursive: true });
}

// Configure multer storage
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, 'uploads/');
    },
    filename: function (req, file, cb) {
        // Generate unique filename with timestamp
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        const ext = path.extname(file.originalname);
        cb(null, file.fieldname + '-' + uniqueSuffix + ext);
    }
});

// File filter to accept only images
const fileFilter = (req, file, cb) => {
    if (file.mimetype.startsWith('image/')) {
        cb(null, true);
    } else {
        cb(new Error('Only image files are allowed!'), false);
    }
};

// Initialize multer
const upload = multer({
    storage: storage,
    limits: {
        fileSize: 5 * 1024 * 1024 // 5MB limit
    },
    fileFilter: fileFilter
});

// Upload endpoint (matches your Flutter route)
app.post('/api/upload/image', upload.single('file'), (req, res) => {
    try {
        if (!req.file) {
            return res.status(400).json({
                success: false,
                message: 'No file uploaded'
            });
        }

        // File uploaded successfully
        const fileInfo = {
            filename: req.file.filename,
            originalName: req.file.originalname,
            size: req.file.size,
            path: req.file.path,
            url: `${req.protocol}://${req.get('host')}/uploads/${req.file.filename}`
        };

        console.log('File uploaded:', fileInfo);

        res.status(200).json({
            success: true,
            message: 'Image uploaded successfully',
            data: fileInfo
        });

    } catch (error) {
        console.error('Upload error:', error);
        res.status(500).json({
            success: false,
            message: 'Server error during upload',
            error: error.message
        });
    }
});

// Serve static files (uploaded images)
app.use('/uploads', express.static('uploads'));

// Error handling middleware
app.use((err, req, res, next) => {
    if (err instanceof multer.MulterError) {
        if (err.code === 'FILE_TOO_LARGE') {
            return res.status(413).json({
                success: false,
                message: 'File too large. Maximum size is 5MB'
            });
        }
        return res.status(400).json({
            success: false,
            message: err.message
        });
    }
    res.status(500).json({
        success: false,
        message: err.message || 'Internal server error'
    });
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
```

## **2. Package.json**

```json
{
  "name": "image-upload-api",
  "version": "1.0.0",
  "description": "Image upload API for Flutter app",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "multer": "^1.4.5-lts.1"
  },
  "devDependencies": {
    "nodemon": "^2.0.22"
  }
}
```

## **3. Advanced Version with Database Integration (MongoDB)**

If you want to store upload metadata in a database:

```javascript
// models/Image.js
const mongoose = require('mongoose');

const ImageSchema = new mongoose.Schema({
    filename: {
        type: String,
        required: true
    },
    originalName: {
        type: String,
        required: true
    },
    size: {
        type: Number,
        required: true
    },
    path: {
        type: String,
        required: true
    },
    url: {
        type: String,
        required: true
    },
    uploadedBy: {
        type: String,
        default: 'anonymous'
    },
    createdAt: {
        type: Date,
        default: Date.now
    }
});

module.exports = mongoose.model('Image', ImageSchema);
```

```javascript
// server-with-db.js
const express = require('express');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const mongoose = require('mongoose');
const Image = require('./models/Image');

const app = express();
const PORT = process.env.PORT || 3000;

// MongoDB connection
mongoose.connect('mongodb://localhost:27017/image_upload', {
    useNewUrlParser: true,
    useUnifiedTopology: true
});

// ... (multer configuration same as above)

// Upload endpoint with database save
app.post('/api/upload/image', upload.single('file'), async (req, res) => {
    try {
        if (!req.file) {
            return res.status(400).json({
                success: false,
                message: 'No file uploaded'
            });
        }

        // Save file info to database
        const image = new Image({
            filename: req.file.filename,
            originalName: req.file.originalname,
            size: req.file.size,
            path: req.file.path,
            url: `${req.protocol}://${req.get('host')}/uploads/${req.file.filename}`,
            uploadedBy: req.body.uploadedBy || 'anonymous'
        });

        await image.save();

        res.status(200).json({
            success: true,
            message: 'Image uploaded successfully',
            data: image
        });

    } catch (error) {
        console.error('Upload error:', error);
        // Clean up uploaded file if database save fails
        if (req.file) {
            fs.unlink(req.file.path, (err) => {
                if (err) console.error('Error deleting file:', err);
            });
        }
        res.status(500).json({
            success: false,
            message: 'Server error during upload',
            error: error.message
        });
    }
});

// Get all images
app.get('/api/images', async (req, res) => {
    try {
        const images = await Image.find().sort({ createdAt: -1 });
        res.json({
            success: true,
            data: images
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: error.message
        });
    }
});

// Get single image
app.get('/api/images/:id', async (req, res) => {
    try {
        const image = await Image.findById(req.params.id);
        if (!image) {
            return res.status(404).json({
                success: false,
                message: 'Image not found'
            });
        }
        res.json({
            success: true,
            data: image
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: error.message
        });
    }
});

// Delete image
app.delete('/api/images/:id', async (req, res) => {
    try {
        const image = await Image.findById(req.params.id);
        if (!image) {
            return res.status(404).json({
                success: false,
                message: 'Image not found'
            });
        }

        // Delete file from filesystem
        fs.unlink(image.path, (err) => {
            if (err) console.error('Error deleting file:', err);
        });

        // Delete from database
        await image.deleteOne();

        res.json({
            success: true,
            message: 'Image deleted successfully'
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: error.message
        });
    }
});

// ... (rest of the server code)
```

## **4. Environment Variables (.env)**

```
PORT=3000
MONGODB_URI=mongodb://localhost:27017/image_upload
MAX_FILE_SIZE=5242880
UPLOAD_DIR=uploads
```

## **Installation & Running**

```bash
# Install dependencies
npm install

# Run with nodemon (development)
npm run dev

# Run production
npm start
```

## **Flutter Constants Configuration**

In your Flutter app, update your `Constants.dart`:

```dart
class Constants {
  // For local development (Android Emulator)
  static const String BASE_URL = 'http://10.0.2.2:3000';
  
  // For iOS Simulator
  // static const String BASE_URL = 'http://localhost:3000';
  
  // For real device on same network
  // static const String BASE_URL = 'http://192.168.1.xxx:3000';
  
  // For production
  // static const String BASE_URL = 'https://your-domain.com';
  
  static const String IMAGE_UPLOAD_ROUTE = '/api/upload/image';
  static const String IMAGES_ROUTE = '/api/images';
}
```

This Node.js backend:
- Handles multipart form uploads
- Validates file types (images only)
- Limits file size (5MB)
- Saves files with unique names
- Returns file information to the client
- Serves static files for viewing uploaded images
- Includes error handling and logging
