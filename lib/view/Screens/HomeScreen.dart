import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/core/appcolor.dart';
import 'package:movie_app/view/Screens/searchScreen.dart';


import 'package:flutter_bloc/flutter_bloc.dart';

import '../../view_model/nowPlaying/now_playing_cubit.dart';
import '../../view_model/popular/popular_cubit.dart';
import '../../view_model/topRated/top_rated_cubit.dart';
import '../../view_model/upComming/up_comming_cubit.dart';
import '../Widgets/gesture.dart';
import '../Widgets/gridView.dart';
import '../Widgets/text.dart';
import '../Widgets/textForm.dart';
import 'detailsScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    context.read<TopRatedCubit>().getTopRatedMovies();
    context.read<UpcomingCubit>().getUpcomingMovies();
    context.read<PopularCubit>().getPopularMovie();
    context.read<NowPlayingCubit>().getNowPlayingMovie();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGround,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.backGround,
        centerTitle: true,
        title: Text(
          'What do you want to watch?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textWhite,
          ),
        ),
      ),
      body: BlocBuilder<TopRatedCubit, TopRatedState>(
        builder: (context, state) {
          if (state is TopRatedLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TopRatedSuccess) {
            final topRatedMovie = state.topRatedMovie.results;
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Expanded(
                  child: Column(
                    children: [
                      CustomTextForm(
                        readOnly: true,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SearchScreen(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 34),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.iconHint,
                              blurRadius: 40,
                              spreadRadius: -20,
                            ),
                          ],
                        ),
                        child: CarouselSlider.builder(
                          itemCount: topRatedMovie.length,
                          itemBuilder: (context, index, realIndex) {
                            final topRate = topRatedMovie[index];
                            return SizedGestureClip(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailsScreen(movie: topRate),
                                  ),
                                );
                              },
                              path:
                              "https://image.tmdb.org/t/p/w500${topRate.posterPath}",
                            );
                          },
                          options: CarouselOptions(
                            autoPlayAnimationDuration: Duration(seconds: 2),
                            autoPlay: true,
                            viewportFraction: 0.4,
                            enlargeCenterPage: true,
                            autoPlayCurve: Curves.fastOutSlowIn,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      DefaultTabController(
                        length: 4,
                        child: Expanded(
                          child: Column(
                            children: [
                              TabBar(
                                labelPadding: EdgeInsets.symmetric(horizontal: 15),
                                overlayColor: MaterialStateProperty.all(
                                  Colors.transparent,
                                ),
                                isScrollable: true,
                                dividerColor: AppColors.backGround,
                                unselectedLabelColor: AppColors.iconHint,
                                indicatorWeight: 5,
                                labelColor: AppColors.textWhite,
                                indicatorColor: AppColors.detail,
                                tabAlignment: TabAlignment.start,
                                tabs: [
                                  Tab(text: 'Now playing'),
                                  Tab(text: 'Upcoming'),
                                  Tab(text: 'Top rated'),
                                  Tab(text: 'Popular'),
                                ],
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  child: TabBarView(
                                    children: [

                                      BlocBuilder<NowPlayingCubit, NowPlayingState>(
                                        builder: (context, state) {
                                          if (state is NowPlayingLoading){
                                            return Center(child: CircularProgressIndicator(),);
                                          }else if (state is NowPlayingSuccess){
                                            final nowPlayingMovie = state.nowPlayingMovie.results??[];
                                            return CustomGridviewBuilder(
                                              itemCount: nowPlayingMovie.length,
                                              itemBuilder: (context, i) {
                                                final nowPlay = nowPlayingMovie[i];
                                                return SizedGestureClip(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailsScreen(movie: nowPlay),
                                                      ),
                                                    );
                                                  },
                                                  path:
                                                  "https://image.tmdb.org/t/p/w500${nowPlay.posterPath}",
                                                );
                                              },
                                            );
                                          }else if (state is NowPlayingError){
                                            return TextDetails(title: 'Error: ${state.message}');
                                          }else{
                                            return TextDetails(title: 'Nothing to Show');
                                          }
                                        },
                                      ),
                                      BlocBuilder<UpcomingCubit, UpcomingState>(
                                        builder: (context, state) {
                                          if (state is UpcomingMovieLoading) {
                                            return Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          } else if (state
                                          is UpcomingMovieSuccess) {
                                            final upComingMovie =
                                                state.upComingMovie.results;
                                            return CustomGridviewBuilder(
                                              itemCount: upComingMovie.length,
                                              itemBuilder: (context, i) {
                                                final upComing = upComingMovie[i];
                                                return SizedGestureClip(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailsScreen(
                                                              movie: upComing,
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                  path:
                                                  "https://image.tmdb.org/t/p/w500${upComing.posterPath}",
                                                );
                                              },
                                            );
                                          } else if (state is UpcomingMovieError) {
                                            return TextDetails(
                                              title: 'Error: ${state.message}',
                                            );
                                          } else {
                                            return TextDetails(
                                              title: 'No Movies is Coming soon',
                                            );
                                          }
                                        },
                                      ),
                                      CustomGridviewBuilder(
                                        itemCount: topRatedMovie.length,
                                        itemBuilder: (context, i) {
                                          final topRate = topRatedMovie[i];
                                          return SizedGestureClip(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailsScreen(movie: topRate),
                                                ),
                                              );
                                            },
                                            path:
                                            "https://image.tmdb.org/t/p/w500${topRate.posterPath}",
                                          );
                                        },
                                      ),

                                      BlocBuilder<PopularCubit, PopularState>(
                                        builder: (context, state) {
                                          if (state is PopularMovieLoading){
                                            return Center(child: CircularProgressIndicator(),);
                                          }else if (state is PopularMovieSuccess){
                                            final popularMovie = state.popularMovie.results;
                                            return CustomGridviewBuilder(
                                              itemCount: topRatedMovie.length,
                                              itemBuilder: (context, i) {
                                                final popMovie = popularMovie[i];
                                                return SizedGestureClip(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailsScreen(movie: popMovie),
                                                      ),
                                                    );
                                                  },
                                                  path:
                                                  "https://image.tmdb.org/t/p/w500${popMovie.posterPath}",
                                                );
                                              },
                                            );
                                          }else if (state is PopularMovieError){
                                            return TextDetails(title: 'Error: ${state.message}');
                                          }else{
                                            return TextDetails(title: 'Nothing To Show');
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is TopRatedError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return Scaffold(
              body: SafeArea(
                child: Center(child: Text("Oops There is An Error")),
              ),
            );
          }
        },
      ),
    );
  }
}