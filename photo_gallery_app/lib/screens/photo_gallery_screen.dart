import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallery_app/bloc/gallery_cubit.dart';


class PhotoGallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GalleryCubit, GalleryState>(
      builder: (context, state) {
        // if dont loaded
        if (state is GalleryLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is ImagesLoaded) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: GridView.builder(
                  itemCount: state.images.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                  ),
                  itemBuilder: (context, index) {
                    return Image.network(
                      state.images[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
          );
        }

        return Container(child: Text('Wat'),);
      },
    );
  }
}
