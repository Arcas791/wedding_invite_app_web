class Guest {
  final String name;
  final String email;

  Guest({
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
      };
}
