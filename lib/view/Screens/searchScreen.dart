import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';


import '../../core/appcolor.dart';
import '../../view_model/movieDetails/details_cubit.dart';
import '../../view_model/search/search_cubit.dart';
import '../Widgets/appBar.dart';
import '../Widgets/searchDetails.dart';
import '../Widgets/text.dart';
import '../Widgets/textForm.dart';
import 'detailsScreen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGround,
      appBar: CustomAppBar(
        toolTipMessage: 'Search about what do you want',
        angle: 3.1,
        title: 'Search',
        sufIcon: Icon(
          Icons.info_outline_rounded,
          color: AppColors.appBarColor,
          size: 25,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            CustomTextForm(
              readOnly: false,
              controller: searchController,
              onSubmit: (value) {
                if (value.isNotEmpty) {
                  context.read<SearchMovieCubit>().getSearchMovies(value);
                }
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<SearchMovieCubit, SearchMovieState>(
                builder: (context, state) {
                  if (state is SearchMovieLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is SearchMovieSuccess) {
                    final searchMovie = state.searchMovie.results;
                    if (searchMovie.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/icons/no-results_1.svg"),
                            SizedBox(height: 15,),
                            const Text('we are sorry, we can', style: TextStyle(fontSize: 16, color: AppColors.textWhite, fontWeight: FontWeight.w400, letterSpacing: .12)),
                            const Text('not find the movie', style: TextStyle(fontSize: 16, color: AppColors.textWhite, fontWeight: FontWeight.w400, letterSpacing: .12))
                            ,const Text('Find your movie by Type title categories, years, etc ', style: TextStyle(fontSize: 16, color: AppColors.textWhite, fontWeight: FontWeight.w400, letterSpacing: .12),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: searchMovie.length,
                        itemBuilder: (context, index) {
                          final searchS = searchMovie[index];
                          final movieGenres = searchS.genreIds !=null&& searchS.genreIds.isNotEmpty
                              ?searchS.genreIds![0].toString()
                              :"";
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: SizedBox(
                              height: 180,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(26),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      children: [
                                        GestureDetector(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              26,
                                            ),
                                            child: Image.network(
                                              searchS.posterPath != null
                                                  ? "https://image.tmdb.org/t/p/w500${searchS.posterPath}"
                                                  :searchS.backdropPath !=null
                                                  ?"https://image.tmdb.org/t/p/w500${searchS.backdropPath}"
                                                  :"https://img.icons8.com/?size=100&id=6i8IfGyeoebS&format=png&color=000000",
                                              width: 120,
                                              height: 170,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailsScreen(movie:searchS),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                        child: BlocProvider(
                                          create: (context) => DetailsCubit()..getDetailsMovie(searchS.id),
                                          child: BlocBuilder<DetailsCubit, DetailsState>(
                                            builder: (context, state) {
                                              if (state is DetailsMovieSuccess){
                                                final detailsMovie = state.detailsMovie.genres??[];
                                                final time = state.detailsMovie.runtime!=null?"${state.detailsMovie.runtime}" : "0";
                                                final genres = detailsMovie.isNotEmpty ? detailsMovie[0] : null;
                                                return CustomDetailsCoulmn(
                                                  movieName: searchS.title,
                                                  movieRate: searchS.voteAverage,
                                                  movieType:genres?.name??"UnKnown",
                                                  movieYear: searchS.releaseDate,
                                                  movieTime: time,
                                                );
                                              }else if (state is DetailsMovieError){
                                                return TextDetails(title: "Error ${state.message}");
                                              }else{
                                                return Center(child:const Text("Oops"),);
                                              }
                                            },
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  } else if (state is SearchMovieError) {
                    return Center(child: Text('Error : ${state.message}'));
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/icons/no-results_1.svg"),
                          SizedBox(height: 20),
                          const Text(
                            'Find your movie by Type title ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.iconHint,
                              letterSpacing: 0.12,
                            ),),SizedBox(height: 5,),
                          const Text(
                            'categories, years, etc ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.iconHint,
                              letterSpacing: 0.12,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}