import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery_app/services/network_helper.dart';

import '../keys.dart' as keys;

part 'gallery_state.dart';

class GalleryCubit extends Cubit<GalleryState> {
  GalleryCubit() : super(GalleryInitial());



  Future<void> getPhotos() async {
    // for indicator
    emit(GalleryLoading());

    List<String> images = [];

    String url =
        'https://pixabay.com/api/?key=${keys.pixabyApiKey}&image_type=photo';

    NetworkHelper networkHelper = NetworkHelper(url: url);

    dynamic data = await networkHelper.getDate();

    List<dynamic> hitsList = data['hits'] as List;

    for (int i = 0; i < hitsList.length; i++) {
      images.add(data['hits'][i]['largeImageURL']);
    }

    emit(ImagesLoaded(images: images));
  }
}
