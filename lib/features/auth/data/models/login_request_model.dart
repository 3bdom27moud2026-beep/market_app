import 'package:equatable/equatable.dart';

/// Data model representing the login payload for API requests.
class LoginRequestModel extends Equatable {
  final String identifier; // Email or Phone number
  final String password;

  const LoginRequestModel({required this.identifier, required this.password});

  /// Converts model into JSON payload required by backend API.
  Map<String, dynamic> toJson() {
    final isEmail = identifier.contains('@');
    return {
      'login': identifier,
      if (isEmail) 'email': identifier else 'phone': identifier,
      'password': password,
    };
  }

  @override
  List<Object?> get props => [identifier, password];
}
