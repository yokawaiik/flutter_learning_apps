part of 'gallery_cubit.dart';


@immutable
abstract class GalleryState extends Equatable {
  const GalleryState();

  @override
  List<Object> get props => [];
}


class GalleryInitial extends GalleryState {
  const GalleryInitial();


}

class GalleryLoading extends GalleryState {
  const GalleryLoading();

}

class ImagesLoaded extends GalleryState {
  final List<String> images;

  const ImagesLoaded({required this.images});

  @override
  List<Object> get props => [images];
}

class GalleryError extends GalleryState {
  final String message;

  const GalleryError({required this.message});

  @override
  List<Object> get props => [message];
}
