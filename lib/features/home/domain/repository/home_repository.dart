import 'package:dartz/dartz.dart';
import '../entities/home_data_entity.dart';

/// Abstract repository for the home screen data.
///
/// This is the contract for the data layer to implement.
abstract class HomeRepository {
  /// Fetches all home screen data (offers, flash sale, categories, etc.).
  Future<Either<String, HomeDataEntity>> getHomeData();
}
