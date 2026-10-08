/// Helper utility for normalizing and formatting image and asset URLs across the app.
abstract final class ImageUrlFormatter {
  static const String baseDomain = 'https://shopguide.medguide.software';

  /// Normalizes image, logo, and avatar URLs so that all assets correctly resolve
  /// to the backend's `/public/` asset directory (avoiding 403 Forbidden / 404 Not Found).
  static String? format(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    var trimmed = raw.trim();

    // Normalize localhost / 127.0.0.1 developer URLs from backend database
    if (trimmed.contains('127.0.0.1') || trimmed.contains('localhost')) {
      for (final prefix in const [
        'http://127.0.0.1:8000',
        'http://localhost:8000',
        'https://127.0.0.1:8000',
        'https://localhost:8000',
        'http://127.0.0.1',
        'http://localhost',
        'https://127.0.0.1',
        'https://localhost',
      ]) {
        if (trimmed.startsWith(prefix)) {
          trimmed = '$baseDomain${trimmed.substring(prefix.length)}';
          break;
        }
      }
    }

    // If it's already an absolute URL on our domain
    if (trimmed.startsWith(baseDomain)) {
      final path = trimmed.substring(baseDomain.length);
      if (!path.startsWith('/public/')) {
        if (path.startsWith('/storage/') ||
            path.startsWith('/uploads/') ||
            path.startsWith('/images/')) {
          trimmed = '$baseDomain/public$path';
        }
      }
      return trimmed;
    }

    // Other absolute URLs (e.g. Google avatar, CDN, placeholders)
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }

    // Handle relative paths
    if (trimmed.startsWith('/public/storage/')) {
      return '$baseDomain$trimmed';
    } else if (trimmed.startsWith('public/storage/')) {
      return '$baseDomain/$trimmed';
    } else if (trimmed.startsWith('/storage/')) {
      return '$baseDomain/public$trimmed';
    } else if (trimmed.startsWith('storage/')) {
      return '$baseDomain/public/$trimmed';
    } else if (trimmed.startsWith('/public/uploads/')) {
      return '$baseDomain$trimmed';
    } else if (trimmed.startsWith('public/uploads/')) {
      return '$baseDomain/$trimmed';
    } else if (trimmed.startsWith('/uploads/')) {
      return '$baseDomain/public$trimmed';
    } else if (trimmed.startsWith('uploads/')) {
      return '$baseDomain/public/$trimmed';
    } else if (trimmed.startsWith('/public/images/')) {
      return '$baseDomain$trimmed';
    } else if (trimmed.startsWith('public/images/')) {
      return '$baseDomain/$trimmed';
    } else if (trimmed.startsWith('/images/')) {
      return '$baseDomain/public$trimmed';
    } else if (trimmed.startsWith('images/')) {
      return '$baseDomain/public/$trimmed';
    } else if (trimmed.startsWith('avatars/')) {
      return '$baseDomain/public/storage/$trimmed';
    } else if (trimmed.startsWith('/avatars/')) {
      return '$baseDomain/public/storage$trimmed';
    } else if (trimmed.startsWith('/')) {
      return '$baseDomain/public/storage$trimmed';
    } else {
      return '$baseDomain/public/storage/$trimmed';
    }
  }
}
