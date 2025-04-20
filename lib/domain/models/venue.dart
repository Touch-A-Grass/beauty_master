import 'package:beauty_master/domain/models/location.dart';
import 'package:beauty_master/domain/models/venue_theme_config.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue.freezed.dart';
part 'venue.g.dart';

@freezed
class Venue with _$Venue {
  const factory Venue({
    required String id,
    required String name,
    required Location location,
    @Default('') String description,
    @Default(VenueThemeConfig()) VenueThemeConfig theme,
    @Default([]) List<String> photos,
  }) = _Venue;

  factory Venue.fromJson(Map<String, dynamic> json) => _$VenueFromJson(json);
}
