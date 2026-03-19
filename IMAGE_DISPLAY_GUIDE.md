# Product Image Display Guide

## Overview
This guide explains how product images are handled and displayed throughout the EcoLife mobile application.

## Image URL Handling

### Backend Configuration
- Backend stores images in: `/uploads/products/`
- Images are saved with relative paths like: `/uploads/products/product-123456789.jpg`
- Backend serves static files from the uploads directory

### Frontend Configuration
Product images are automatically converted from relative paths to full URLs in the `ProductModel` class.

**Configuration Steps:**

1. **Update Base URL in `lib/utils/constants.dart`:**

```dart
// For Web & iOS Simulator:
static const String imageBaseUrl = 'http://localhost:5000';

// For Android Emulator:
// static const String imageBaseUrl = 'http://10.0.2.2:5000';

// For Physical Device (use your machine's IP):
// static const String imageBaseUrl = 'http://192.168.0.100:5000';
```

2. **Find your machine's IP address:**
   - **Linux/Mac:** Run `ifconfig` or `ip addr show`
   - **Windows:** Run `ipconfig`
   - Look for your local network IP (usually 192.168.x.x or 10.0.x.x)

## Image Display Components

### 1. Product Card (`lib/widgets/common/product_card.dart`)
- Displays product thumbnail (150px height)
- Shows loading indicator while image loads
- Displays error message if image fails to load
- Shows placeholder icon if no image available

### 2. Product Details Screen (`lib/screens/customer/product_details_screen.dart`)
- Displays large product image (300px height)
- Full-width display for better viewing
- Enhanced error handling with descriptive messages

### 3. Cart Item Widget (`lib/widgets/customer/cart_item.dart`)
- Displays small product thumbnail (80x80px)
- Compact display for cart items
- Consistent error handling

### 4. Vendor Product List (`lib/screens/vendor/vendor_products_screen.dart`)
- Displays product thumbnails in vendor's product management
- Same size as cart items (80x80px)

## Image Upload

### Vendor Product Creation/Update
- Images are uploaded using multipart/form-data
- Maximum file size: 5MB
- Allowed formats: JPG, JPEG, PNG, GIF, WEBP
- File field name: `image`

### Upload Process
1. User selects image from device
2. Image is converted to bytes
3. Sent to backend via `postMultipart` in `ApiService`
4. Backend saves image and returns relative path
5. Frontend converts relative path to full URL

## Error Handling

### Image Load Failures
The app handles various image loading scenarios:

1. **Image Loading:**
   - Shows circular progress indicator
   - Displays "Loading..." text

2. **Image Load Error:**
   - Shows broken image icon
   - Displays "Image unavailable" or "Failed to load image"
   - Logs error to console for debugging

3. **No Image:**
   - Shows image not supported icon
   - Displays "No image" or "No image available"

### Debugging Image Issues

If images aren't displaying:

1. **Check console logs:**
   ```
   Image load error for [product-name]: [error]
   Image URL: [full-url]
   ```

2. **Verify base URL is correct:**
   - Check `lib/utils/constants.dart`
   - Ensure it matches your backend URL
   - For physical devices, use your machine's IP

3. **Check backend:**
   - Verify backend is running on correct port
   - Check that static file serving is configured
   - Ensure images exist in `/uploads/products/`

4. **Network connectivity:**
   - Ensure device/emulator can reach backend
   - Test with: `curl http://your-ip:5000/uploads/products/[image-name]`

## Image Caching

The app uses `cached_network_image` package for:
- Automatic image caching
- Reduced network requests
- Faster image loading on subsequent views
- Memory-efficient image handling

## Best Practices

1. **Always provide product images** - Products with images have better visibility
2. **Use appropriate image sizes** - Recommended: 800x800px or larger
3. **Optimize images before upload** - Compress images to reduce file size
4. **Use consistent aspect ratios** - Square images work best (1:1 ratio)
5. **Test on different devices** - Verify images load on emulators and physical devices

## Supported Image Formats

- **JPEG/JPG** - Best for photos
- **PNG** - Best for graphics with transparency
- **WEBP** - Modern format with better compression
- **GIF** - Supported but not recommended for product images

## Troubleshooting

### Images not loading on Android Emulator
- Use `http://10.0.2.2:5000` as base URL
- Check that backend allows requests from 10.0.2.2

### Images not loading on Physical Device
- Use your machine's local network IP (e.g., 192.168.0.100)
- Ensure device is on same network as development machine
- Check firewall settings allow connections on port 5000

### MIME Type Errors
- Backend has been configured to accept `application/octet-stream`
- Valid image extensions are always accepted regardless of MIME type

## Implementation Details

### ProductModel.fromJson()
Automatically converts relative paths to full URLs:
```dart
image: _getFullImageUrl(json['image'])
```

### _getFullImageUrl() Helper
```dart
static String? _getFullImageUrl(String? imagePath) {
  if (imagePath == null || imagePath.isEmpty) return null;
  
  // If already a full URL, return as is
  if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
    return imagePath;
  }
  
  // Convert relative path to full URL
  final path = imagePath.startsWith('/') ? imagePath : '/$imagePath';
  return '${AppConstants.imageBaseUrl}$path';
}
```

This ensures all product images are properly displayed throughout the application.
