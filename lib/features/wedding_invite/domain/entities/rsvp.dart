class Rsvp {
  final String name;
  final bool isAttending;
  final String? allergies;
  final String? songRequests;
  final String? children;
  final bool tomorrowland;

  Rsvp(
      {required this.name,
      required this.isAttending,
      this.allergies,
      this.songRequests,
      this.children,
      required this.tomorrowland});
}
