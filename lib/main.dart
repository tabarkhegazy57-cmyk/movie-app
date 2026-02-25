import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/view/Screens/HomeScreen.dart';
import 'package:movie_app/view/Screens/bottomNavScreen.dart';
import 'package:movie_app/view_model/movieCast/cast_cubit.dart';
import 'package:movie_app/view_model/movieDetails/details_cubit.dart';
import 'package:movie_app/view_model/movieReviews/reviews_cubit.dart';
import 'package:movie_app/view_model/nowPlaying/now_playing_cubit.dart';
import 'package:movie_app/view_model/popular/popular_cubit.dart';
import 'package:movie_app/view_model/search/search_cubit.dart';
import 'package:movie_app/view_model/topRated/top_rated_cubit.dart';
import 'package:movie_app/view_model/upComming/up_comming_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => TopRatedCubit(),
          ),
          BlocProvider(
            create: (context) => SearchMovieCubit(),
          ),
          BlocProvider(
              create: (context) => UpcomingCubit()),
          BlocProvider(
              create:(context) => PopularCubit()),
          BlocProvider(
              create:(context) => NowPlayingCubit()),
          BlocProvider(
              create: (context)=>ReviewsCubit()),
          BlocProvider(
              create:(context)=>CastCubit()),
          BlocProvider(
              create: (context)=>DetailsCubit())
        ],
        child:
       MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Movies', home: BottomNavScreen(),

    ));
  }
}

