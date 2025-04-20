import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization_theme_config.freezed.dart';
part 'organization_theme_config.g.dart';

@freezed
class OrganizationThemeConfig with _$OrganizationThemeConfig {
  const factory OrganizationThemeConfig({
    required int color,
    required String photo,
}) = _OrganizationThemeConfig;

  factory OrganizationThemeConfig.fromJson(Map<String, dynamic> json) => _$OrganizationThemeConfigFromJson(json);
}