import 'package:flutter_test/flutter_test.dart';
import 'package:market/core/utils/image_url_formatter.dart';
import 'package:market/features/profile/data/models/profile_model.dart';

void main() {
  group('ProfileModel Avatar Parsing', () {
    test('formats relative avatar path starting with avatars/', () {
      final json = {
        'id': 1,
        'name': 'Test User',
        'email': 'test@example.com',
        'avatar': 'avatars/fUOe61j96FT23LzLkoNn3lZx6f8l49oHg89p5dIe.jpg',
      };
      final model = ProfileModel.fromJson(json);
      expect(
        model.avatarUrl,
        'https://shopguide.medguide.software/public/storage/avatars/fUOe61j96FT23LzLkoNn3lZx6f8l49oHg89p5dIe.jpg',
      );
    });

    test('formats relative avatar path starting with storage/', () {
      final json = {
        'id': 1,
        'name': 'Test User',
        'email': 'test@example.com',
        'avatar': 'storage/avatars/sample.jpg',
      };
      final model = ProfileModel.fromJson(json);
      expect(
        model.avatarUrl,
        'https://shopguide.medguide.software/public/storage/avatars/sample.jpg',
      );
    });

    test('formats relative avatar path starting with /storage/', () {
      final json = {
        'id': 1,
        'name': 'Test User',
        'email': 'test@example.com',
        'avatar': '/storage/avatars/sample.jpg',
      };
      final model = ProfileModel.fromJson(json);
      expect(
        model.avatarUrl,
        'https://shopguide.medguide.software/public/storage/avatars/sample.jpg',
      );
    });

    test('preserves absolute HTTP/HTTPS avatar URL', () {
      final json = {
        'id': 1,
        'name': 'Test User',
        'email': 'test@example.com',
        'avatar': 'https://cdn.example.com/avatar.jpg',
      };
      final model = ProfileModel.fromJson(json);
      expect(model.avatarUrl, 'https://cdn.example.com/avatar.jpg');
    });

    test('rewrites own-domain URLs lacking public path to public path', () {
      final json = {
        'id': 1,
        'name': 'Test User',
        'email': 'test@example.com',
        'avatar':
            'https://shopguide.medguide.software/storage/avatars/old_path.jpg',
      };
      final model = ProfileModel.fromJson(json);
      expect(
        model.avatarUrl,
        'https://shopguide.medguide.software/public/storage/avatars/old_path.jpg',
      );
    });

    test('returns null for empty or null avatar', () {
      final json1 = {
        'id': 1,
        'name': 'Test User',
        'email': 'test@example.com',
        'avatar': '',
      };
      final json2 = {
        'id': 1,
        'name': 'Test User',
        'email': 'test@example.com',
        'avatar': null,
      };
      expect(ProfileModel.fromJson(json1).avatarUrl, isNull);
      expect(ProfileModel.fromJson(json2).avatarUrl, isNull);
    });
  });

  group('ImageUrlFormatter Tests', () {
    test('formats uploads directory correctly', () {
      expect(
        ImageUrlFormatter.format(
          'https://shopguide.medguide.software/uploads/1788858153_2re8PQ2h.jpg',
        ),
        'https://shopguide.medguide.software/public/uploads/1788858153_2re8PQ2h.jpg',
      );

      expect(
        ImageUrlFormatter.format('uploads/1788858153_2re8PQ2h.jpg'),
        'https://shopguide.medguide.software/public/uploads/1788858153_2re8PQ2h.jpg',
      );
    });

    test('leaves already formatted public URLs untouched', () {
      expect(
        ImageUrlFormatter.format(
          'https://shopguide.medguide.software/public/storage/avatars/pic.jpg',
        ),
        'https://shopguide.medguide.software/public/storage/avatars/pic.jpg',
      );
    });
  });
}
