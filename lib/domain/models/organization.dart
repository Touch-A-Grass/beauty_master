import 'package:beauty_master/domain/models/organization_theme_config.dart';
import 'package:beauty_master/domain/models/organization_theme_config.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization.freezed.dart';
part 'organization.g.dart';

@freezed
class Organization with _$Organization {
  const factory Organization({
    required String id,
    required String name,
    @Default('') String description,
    @Default('') String subscription,
    required OrganizationThemeConfig theme,
  }) = _Organization;

  factory Organization.fromJson(Map<String, dynamic> json) => _$OrganizationFromJson(json);
}
