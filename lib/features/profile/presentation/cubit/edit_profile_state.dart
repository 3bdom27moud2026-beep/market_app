import 'package:equatable/equatable.dart';
import 'package:market/features/profile/domain/entities/profile_entity.dart';

enum EditProfileStatus { initial, submitting, success, failure }

class EditProfileState extends Equatable {
  final EditProfileStatus status;
  final ProfileDataEntity? updatedProfile;
  final String? errorMessage;
  final bool isUploadingAvatar;
  final String? avatarSuccessMessage;
  final String? avatarErrorMessage;

  const EditProfileState({
    this.status = EditProfileStatus.initial,
    this.updatedProfile,
    this.errorMessage,
    this.isUploadingAvatar = false,
    this.avatarSuccessMessage,
    this.avatarErrorMessage,
  });

  EditProfileState copyWith({
    EditProfileStatus? status,
    ProfileDataEntity? updatedProfile,
    String? errorMessage,
    bool? isUploadingAvatar,
    String? avatarSuccessMessage,
    String? avatarErrorMessage,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      updatedProfile: updatedProfile ?? this.updatedProfile,
      errorMessage: errorMessage ?? this.errorMessage,
      isUploadingAvatar: isUploadingAvatar ?? this.isUploadingAvatar,
      avatarSuccessMessage: avatarSuccessMessage ?? this.avatarSuccessMessage,
      avatarErrorMessage: avatarErrorMessage ?? this.avatarErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    updatedProfile,
    errorMessage,
    isUploadingAvatar,
    avatarSuccessMessage,
    avatarErrorMessage,
  ];
}
