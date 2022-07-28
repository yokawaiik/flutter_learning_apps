import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spot_the_bird/bloc/bird_post_cubit.dart';
import 'package:spot_the_bird/bloc/location_cubit.dart';
import 'package:spot_the_bird/screens/map_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocationCubit>(
          create: (BuildContext context) => LocationCubit()..getLocation(),
        ),
        BlocProvider<BirdPostCubit>(
          create: (BuildContext context) => BirdPostCubit()..loadPosts(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData( 
          primaryColor: Color(0xFFE2C2B9),
          colorScheme: ColorScheme.light().copyWith(
            // TextField color
            primary: Color(0xFFBFD8B8),
            // floatingActionButton
            secondary: Color(0xFFE7EAB5),
          ),
        ),
        home: MapScreen(),
      ),
    );
  }
}
