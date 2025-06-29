class Rsvp {
  final String name;
  final bool isAttending;
  final String? bus;
  final String? allergies;
  final String? songRequests;
  final String? companionName;
  final String? children;
  final List<String>? childrenNames;
  final List<String>? childrenAges;
  final bool tomorrowland;
  final String? createdAt;

  Rsvp(
      {required this.name,
      required this.isAttending,
      this.bus,
      this.allergies,
      this.songRequests,
      this.companionName,
      this.children,
      this.childrenNames,
      this.childrenAges,
      required this.tomorrowland,
      this.createdAt});
}
