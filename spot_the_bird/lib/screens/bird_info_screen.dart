import 'package:flutter/material.dart';
import 'package:spot_the_bird/bloc/bird_post_cubit.dart';
import 'package:spot_the_bird/models/bird_post_model.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class BirdInfoScreen extends StatelessWidget {
  final BirdModel birdModel;

  const BirdInfoScreen({Key? key, required this.birdModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          birdModel.birdName!,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width / 1.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(birdModel.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              birdModel.birdName!,
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              birdModel.birdDescription!,
              style: Theme.of(context).textTheme.headline6,
            ),
            TextButton(
              onPressed: () {
                //  Todo: delete this post
                context.read<BirdPostCubit>().removeBirdPost(birdModel);
                
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            )
          ],
        ),
      ),
    );
  }
}
