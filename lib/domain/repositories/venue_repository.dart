import 'package:beauty_master/domain/models/venue.dart';

abstract interface class VenueRepository {
  Future<Venue> getVenue(String id);
}
