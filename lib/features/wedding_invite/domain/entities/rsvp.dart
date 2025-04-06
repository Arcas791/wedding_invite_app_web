class Rsvp {
  final String name;
  final bool isAttending;
  final String? allergies;
  final String? songRequests;

  Rsvp({
    required this.name,
    required this.isAttending,
    this.allergies,
    this.songRequests,
  });
}
