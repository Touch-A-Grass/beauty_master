import 'package:beauty_master/presentation/util/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue_theme_config.freezed.dart';
part 'venue_theme_config.g.dart';

@freezed
class VenueThemeConfig with _$VenueThemeConfig {
  const factory VenueThemeConfig({
    @ColorConverter() @Default(Colors.black) Color color,
    @Default('https://i.imgur.com/RB2AK8H.jpeg') String photo,
  }) = _VenueThemeConfig;

  factory VenueThemeConfig.fromJson(Map<String, dynamic> json) => _$VenueThemeConfigFromJson(json);
}

class ColorConverter implements JsonConverter<Color, String> {
  const ColorConverter();

  @override
  Color fromJson(String json) {
    return HexColor.fromHex(json);
  }

  @override
  String toJson(Color object) {
    return object.toHex();
  }
}
