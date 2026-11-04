class Movie {
  final String id;
  final String title;
  final String ageRating;
  final String description;
  final double ticketPrice;
  final String imagePath;
  final List<String> screeningTime;

  const Movie({
    required this.id,
    required this.title,
    required this.ageRating,
    required this.description,
    required this.ticketPrice,
    required this.imagePath,
    required this.screeningTime,
  });

  String get formattedPrice => '£${ticketPrice.toStringAsFixed(2)}';
  bool get isChildFriendly => ageRating == 'U' || ageRating == 'PG';
  bool get isAdultOnly => ageRating == '18';

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as String,
      title: json['title'] as String,
      ageRating: json['ageRating'] as String,
      description: json['description'] as String,
      ticketPrice: (json['ticketPrice'] as num).toDouble(),
      imagePath: json['imagePath'] as String,
      screeningTime: List<String>.from(json['screeningTime'] as List),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'ageRating': ageRating,
        'description': description,
        'ticketPrice': ticketPrice,
        'imagePath': imagePath,
        'screeningTime': screeningTime,
      };
}
