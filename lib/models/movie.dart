class Movie {
  final String id;
  final String title;
  final String ageRating;
  final String description;
  final String imagePath;
  final List<String> screeningTime;

  const Movie(
      {required this.id,
      required this.title,
      required this.ageRating,
      required this.description,
      required this.imagePath,
      required this.screeningTime});
}
