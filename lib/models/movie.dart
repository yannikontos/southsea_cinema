class Movie {
  final String id;
  final String title;
  final String ageRating;
  final String description;
  final double ticketPrice;
  final String imagePath;
  final List<String> screeningTime;

  const Movie(
      {required this.id,
      required this.title,
      required this.ageRating,
      required this.description,
      required this.ticketPrice,
      required this.imagePath,
      required this.screeningTime});

  String get formattedPrice => '£${ticketPrice.toStringAsFixed(2)}';
  bool get isChildFriendly => ageRating == 'U' || ageRating == 'PG';
  bool get isAdultOnly => ageRating == '18';
}
