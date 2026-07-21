import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_pair_model.freezed.dart';
part 'token_pair_model.g.dart';

/// The `/auth/refresh` response DTO (§19) — deliberately narrower than
/// [UserModel]: a refresh call only needs a new token pair, not the full
/// profile, so this doesn't carry `id`/`email`/`role`.
@freezed
abstract class TokenPairModel with _$TokenPairModel {
  const factory TokenPairModel({
    required String accessToken,
    required String refreshToken,
  }) = _TokenPairModel;

  factory TokenPairModel.fromJson(Map<String, dynamic> json) =>
      _$TokenPairModelFromJson(json);
}
