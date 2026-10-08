import 'package:equatable/equatable.dart';
import '../../domain/entities/profile_entity.dart';

/// Loading status for the profile screen.
enum LoadingStatus {
  initial,
  loading,
  loaded,
  error,
  refreshing,
  unauthenticated,
}

/// State for the Profile Cubit.
class ProfileState extends Equatable {
  final LoadingStatus loadingStatus;
  final ProfileDataEntity? profileData;
  final String? errorMessage;

  const ProfileState({
    this.loadingStatus = LoadingStatus.initial,
    this.profileData,
    this.errorMessage,
  });

  ProfileState copyWith({
    LoadingStatus? loadingStatus,
    ProfileDataEntity? profileData,
    String? errorMessage,
  }) {
    return ProfileState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      profileData: profileData ?? this.profileData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [loadingStatus, profileData, errorMessage];
}
