import 'package:beauty_master/data/api/beauty_client.dart';
import 'package:beauty_master/domain/models/venue.dart';
import 'package:beauty_master/domain/repositories/venue_repository.dart';

class VenueRepositoryImpl implements VenueRepository {
  final BeautyClient _api;

  VenueRepositoryImpl(this._api);

  @override
  Future<Venue> getVenue(String id) {
    return _api.getVenue(id);
  }
}
