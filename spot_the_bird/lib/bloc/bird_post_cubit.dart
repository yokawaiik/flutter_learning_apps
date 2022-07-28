import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spot_the_bird/models/bird_post_model.dart';
import 'package:spot_the_bird/services/sqflite.dart';

part 'bird_post_state.dart';

class BirdPostCubit extends Cubit<BirdPostState> {
  BirdPostCubit()
      : super(
          BirdPostState(
            birdPosts: [],
            status: BirdPostStatus.initial,
          ),
        );

  final dbHelper = DatabaseHelper.instance;

  Future<void> addBirdPost(BirdModel birdModel) async {
    emit(state.copyWith(status: BirdPostStatus.loading));
    List<BirdModel> birdPosts = state.birdPosts;

    birdPosts.add(birdModel);

    Map<String, dynamic> row = {
      DatabaseHelper.columnTitle: birdModel.birdName,
      DatabaseHelper.columnDescription: birdModel.birdDescription,
      DatabaseHelper.latitude: birdModel.latitude,
      DatabaseHelper.longitude: birdModel.longitude,
      DatabaseHelper.columnUrl: birdModel.image.path,
    };

    final int? id = await dbHelper.insert(row);
    birdModel.id = id;

    emit(state.copyWith(birdPosts: birdPosts, status: BirdPostStatus.loaded));
  }

  Future<void> removeBirdPost(BirdModel birdModel) async {
    emit(state.copyWith(status: BirdPostStatus.loading));

    List<BirdModel> birdPosts = state.birdPosts;
    birdPosts.removeWhere((element) => element == birdModel);

    await dbHelper.delete(birdModel.id!);

    emit(state.copyWith(status: BirdPostStatus.loaded));
  }

  Future<void> loadPosts() async {
    emit(state.copyWith(status: BirdPostStatus.loading));

    List<BirdModel> birdPosts = [];

    final List<Map<String, dynamic>> rows = await dbHelper.qureyAllRows();
    if (rows.length == 0) {
      print('Rows are empty');
    } else {
      print('Rows has a data');

      for (var row in rows) {
        birdPosts.add(BirdModel(
          id: row['id'],
          birdName: row['birdName'],
          latitude: row['latitude'],
          longitude: row['longitude'],
          image: File(row['url']),
          birdDescription: row['birdDescription'],
        ));
      }
    }

    emit(state.copyWith(
      birdPosts: birdPosts,
      status: BirdPostStatus.loaded,
    ));
  }

  Future<void> _saveToSharedPrefs(List<BirdModel> posts) async {}
}
