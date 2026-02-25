class NowPlayingModel {
  Dates? dates;
  int? page;
  List<Movie>? results;
  int? totalPages;
  int? totalResults;

  NowPlayingModel({
    this.dates,
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  factory NowPlayingModel.fromJson(Map<String, dynamic> json) => NowPlayingModel(
    dates: json['dates'] != null ? Dates.fromJson(json['dates']) : null,
    page: json['page'],
    results: json['results'] != null
        ? List<Movie>.from(json['results'].map((x) => Movie.fromJson(x)))
        : [],
    totalPages: json['total_pages'],
    totalResults: json['total_results'],
  );

  Map<String, dynamic> toJson() => {
    'dates': dates?.toJson(),
    'page': page,
    'results': results != null
        ? List<dynamic>.from(results!.map((x) => x.toJson()))
        : [],
    'total_pages': totalPages,
    'total_results': totalResults,
  };
}

class Dates {
  String? maximum;
  String? minimum;

  Dates({this.maximum, this.minimum});

  factory Dates.fromJson(Map<String, dynamic> json) => Dates(
    maximum: json['maximum'],
    minimum: json['minimum'],
  );

  Map<String, dynamic> toJson() => {
    'maximum': maximum,
    'minimum': minimum,
  };
}

class Movie {
  bool? adult;
  String? backdropPath;
  List<int>? genreIds;
  int? id;
  String? originalLanguage;
  String? originalTitle;
  String? overview;
  double? popularity;
  String? posterPath;
  String? releaseDate;
  String? title;
  bool? video;
  double? voteAverage;
  int? voteCount;

  Movie({
    this.adult,
    this.backdropPath,
    this.genreIds,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
    adult: json['adult'],
    backdropPath: json['backdrop_path'],
    genreIds: json['genre_ids'] != null
        ? List<int>.from(json['genre_ids'])
        : [],
    id: json['id'],
    originalLanguage: json['original_language'],
    originalTitle: json['original_title'],
    overview: json['overview'],
    popularity: json['popularity']?.toDouble(),
    posterPath: json['poster_path'],
    releaseDate: json['release_date'],
    title: json['title'],
    video: json['video'],
    voteAverage: json['vote_average']?.toDouble(),
    voteCount: json['vote_count'],
  );

  Map<String, dynamic> toJson() => {
    'adult': adult,
    'backdrop_path': backdropPath,
    'genre_ids': genreIds,
    'id': id,
    'original_language': originalLanguage,
    'original_title': originalTitle,
    'overview': overview,
    'popularity': popularity,
    'poster_path': posterPath,
    'release_date': releaseDate,
    'title': title,
    'video': video,
    'vote_average': voteAverage,
    'vote_count': voteCount,
  };
}