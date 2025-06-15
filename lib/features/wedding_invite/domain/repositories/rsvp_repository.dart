import '../entities/rsvp.dart';

abstract class RsvpRepository {
  Future<void> submitRSVP(Rsvp rsvp);
}
