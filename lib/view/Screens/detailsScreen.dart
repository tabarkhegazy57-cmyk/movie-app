import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:movie_app/core/appcolor.dart';
import 'package:movie_app/view/Screens/watchlist.dart';


import '../../view_model/movieCast/cast_cubit.dart';
import '../../view_model/movieDetails/details_cubit.dart';
import '../../view_model/movieReviews/reviews_cubit.dart';
import '../Widgets/appBar.dart';
import '../Widgets/movieDetails.dart';
import '../Widgets/ratingBar.dart';
import '../Widgets/reviewTap.dart';
import '../Widgets/text.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key, this.movie});

  final dynamic movie;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool isWatch = false;

  @override
  void initState() {
    super.initState();
    isWatch = watchListMovies.any((movie) => movie.id == widget.movie.id);
    context.read<ReviewsCubit>().getReviewsMovie(widget.movie.id);
    context.read<CastCubit>().getCastMovie(widget.movie.id);
    context.read<DetailsCubit>().getDetailsMovie(widget.movie.id);
  }

  @override
  Widget build(BuildContext context) {
    final searchS = widget.movie;
    final year = searchS.releaseDate != null && searchS.releaseDate.length >= 4
        ? searchS.releaseDate.substring(0, 4)
        : "Unknown";

    final backUrl = searchS.backdropPath != null
        ? "https://image.tmdb.org/t/p/w500${searchS.backdropPath}"
        : "https://image.tmdb.org/t/p/w500${searchS.posterPath}";
    return Scaffold(
      backgroundColor: AppColors.backGround,
      appBar: CustomAppBar(
        toolTipMessage: 'add to watchlist',
        angle: 0,
        title: 'Details',
        sufIcon: GestureDetector(
          onTap: () {
            setState(() {
              if (isWatch) {
                watchListMovies.remove(widget.movie);
              } else {
                watchListMovies.add(widget.movie);
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.iconHint,
                  content: Center(
                    child: TextDetails(
                      title: isWatch
                          ? "Removed From Watch List"
                          : "Added To Watch List!",
                    ),
                  ),
                  duration: Duration(seconds: 1),
                ),
              );
              isWatch = !isWatch;
            });
          },

          child: SvgPicture.asset(
            isWatch
                ? "assets/icons/top-bar-right.svg"
                : "assets/icons/Save.svg",
          ),

        ),
      ),
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.vertical(
                  bottom: Radius.circular(25),
                ),
                child: Image.network(
                  backUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 30,
                bottom: -80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    searchS.posterPath != null
                        ? "https://image.tmdb.org/t/p/w500${searchS.posterPath}"
                        : "https://image.tmdb.org/t/p/w500${searchS
                        .backdropPath}",
                    height: 170,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: 20,
                bottom: 15,
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return BottomRatingBar();
                      },
                    );
                  },
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.contColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                        vertical: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          SvgPicture.asset("assets/icons/Star.svg"),

                          Padding(
                            padding: const EdgeInsets.only(left: 2.0, right: 4),
                            child: Text(
                              searchS.voteAverage.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: .12,
                                color: AppColors.yellowStar,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          BlocBuilder<DetailsCubit, DetailsState>(
            builder: (context, state) {
              if (state is DetailsMovieSuccess){
                final detailsMovie = state.detailsMovie.genres??[];
                final time = state.detailsMovie.runtime!=null?"${state.detailsMovie.runtime}" : "0";
                final genres = detailsMovie.isNotEmpty ? detailsMovie[0] : null;
                return MovieNameTitle(
                  movieName: searchS.originalTitle,
                  movieTime: time,
                  movieYear: searchS.releaseDate,
                  movieType: genres?.name??"",
                );
              }else if(state is DetailsMovieError){
                return Center(child: TextDetails(title: "Error ${state.message}"),);
              }
              return Text("data");
            },
          ),
          DefaultTabController(
            length: 3,
            child: Expanded(
              child: Column(
                children: [
                  TabBar(
                    labelPadding: EdgeInsets.symmetric(horizontal: 25),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    isScrollable: true,
                    dividerColor: AppColors.backGround,
                    unselectedLabelColor: AppColors.iconHint,
                    indicatorWeight: 5,
                    labelColor: AppColors.textWhite,
                    indicatorColor: AppColors.detail,
                    tabAlignment: TabAlignment.start,
                    tabs: [
                      Tab(text: 'About Movie'),
                      Tab(text: 'Reviews'),
                      Tab(text: 'Cast'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [

                        TextDetails(title: searchS.overview),

                        BlocBuilder<ReviewsCubit, ReviewsState>(
                          builder: (context, state) {
                            if (state is ReviewsMovieLoading) {
                              return Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                            } else if (state is ReviewsMovieSuccess) {
                              final reviewsMovie =
                                  state.reviewsMovie.results ?? [];
                              if (reviewsMovie.isEmpty) {
                                return TextDetails(
                                  title: "No reviews available.",
                                );
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                //physics: NeverScrollableScrollPhysics(),
                                itemCount: reviewsMovie.length,
                                itemBuilder: (context, index) {
                                  final review = reviewsMovie[index];
                                  final authorName = review.authorDetails?.name;
                                  final name =
                                  (authorName != null &&
                                      authorName.isNotEmpty)
                                      ? authorName
                                      : "UnKnown";
                                  final avatarPath =
                                      review.authorDetails?.avatarPath;
                                  final String noAvatar =
                                      "https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png";
                                  final imageUrl = avatarPath != null
                                      ? "https://image.tmdb.org/t/p/w200$avatarPath"
                                      : noAvatar;
                                  final content = review.content ?? "";
                                  final rate =
                                  (review.authorDetails?.rating ?? 0)
                                      .toStringAsFixed(1);
                                  return CustomCard(
                                    name: name,
                                    subTitle: content,
                                    image: imageUrl,
                                    rate: rate,
                                  );
                                },
                              );
                            } else if (state is ReviewsMovieError) {
                              return Center(
                                child: TextDetails(
                                  title: "Error: ${state.message}",
                                ),
                              );
                            }
                            return TextDetails(title: "Oops");
                          },
                        ),

                        BlocBuilder<CastCubit, CastState>(
                          builder: (context, state) {
                            if (state is CastMovieLoading) {
                              return Center(child: CircularProgressIndicator());
                            } else if (state is CastMovieSuccess) {
                              final castMovie = state.castMovie.cast ?? [];
                              return Padding(
                                padding: const EdgeInsets.all(15),
                                child: GridView.builder(
                                  shrinkWrap: true,

                                  itemCount: castMovie.length,
                                  gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 4,
                                    crossAxisSpacing: 11,
                                    childAspectRatio: 1,
                                  ),
                                  itemBuilder: (context, index) {
                                    final cast = castMovie[index];
                                    final castAvatar = cast.profilePath;
                                    final castName = cast.name;
                                    final name =
                                    castName != null && castName.isNotEmpty
                                        ? castName
                                        : "UnKnown";
                                    final String noAvatar =
                                        "https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png";
                                    final castUrl = castAvatar != null
                                        ? "https://image.tmdb.org/t/p/w200$castAvatar"
                                        : noAvatar;
                                    return Column(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            castUrl,
                                          ),
                                          radius: 50,
                                        ),
                                        TextDetails(title: name),
                                      ],
                                    );
                                  },
                                ),
                              );
                            } else if (state is CastMovieError) {
                              return TextDetails(
                                title: "Error ${state.message}",
                              );
                            } else {
                              return TextDetails(title: "Oops");
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}