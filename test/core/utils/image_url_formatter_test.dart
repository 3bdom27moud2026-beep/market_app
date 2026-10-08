import 'package:flutter_test/flutter_test.dart';
import 'package:market/core/utils/image_url_formatter.dart';

void main() {
  group('ImageUrlFormatter', () {
    test('returns null for null or empty input', () {
      expect(ImageUrlFormatter.format(null), isNull);
      expect(ImageUrlFormatter.format(''), isNull);
      expect(ImageUrlFormatter.format('   '), isNull);
    });

    test('normalizes localhost and 127.0.0.1 developer URLs', () {
      expect(
        ImageUrlFormatter.format('http://127.0.0.1:8000/images/hero-banner.png'),
        'https://shopguide.medguide.software/public/images/hero-banner.png',
      );
      expect(
        ImageUrlFormatter.format('http://localhost:8000/uploads/test.jpg'),
        'https://shopguide.medguide.software/public/uploads/test.jpg',
      );
    });

    test('inserts /public/ into domain URLs missing it', () {
      expect(
        ImageUrlFormatter.format(
          'https://shopguide.medguide.software/uploads/1788894542_GvMQHzYA.jpg',
        ),
        'https://shopguide.medguide.software/public/uploads/1788894542_GvMQHzYA.jpg',
      );
      expect(
        ImageUrlFormatter.format(
          'https://shopguide.medguide.software/storage/products/item.png',
        ),
        'https://shopguide.medguide.software/public/storage/products/item.png',
      );
    });

    test('preserves URLs that already contain /public/', () {
      expect(
        ImageUrlFormatter.format(
          'https://shopguide.medguide.software/public/uploads/test.jpg',
        ),
        'https://shopguide.medguide.software/public/uploads/test.jpg',
      );
    });

    test('preserves external absolute URLs (Unsplash, CDNs)', () {
      const unsplashUrl =
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=400';
      expect(ImageUrlFormatter.format(unsplashUrl), unsplashUrl);
    });

    test('formats relative paths properly', () {
      expect(
        ImageUrlFormatter.format('/uploads/image.jpg'),
        'https://shopguide.medguide.software/public/uploads/image.jpg',
      );
      expect(
        ImageUrlFormatter.format('uploads/image.jpg'),
        'https://shopguide.medguide.software/public/uploads/image.jpg',
      );
      expect(
        ImageUrlFormatter.format('/storage/image.jpg'),
        'https://shopguide.medguide.software/public/storage/image.jpg',
      );
      expect(
        ImageUrlFormatter.format('storage/image.jpg'),
        'https://shopguide.medguide.software/public/storage/image.jpg',
      );
    });
  });
}
