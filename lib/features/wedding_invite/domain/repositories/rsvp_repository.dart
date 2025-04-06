import '../entities/rsvp.dart';

abstract class RsvpRepository {
  Future<void> saveRsvp(Rsvp rsvp);
}
