import 'package:flutter/material.dart';
import 'package:messenger_app/src/core/models/finded_user.dart';
import 'package:messenger_app/src/modules/messenger/provider/messenger_provider.dart';
import 'package:messenger_app/src/modules/chat/screens/chat_screen.dart';
import 'package:messenger_app/src/modules/profile/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class SearchUsers extends SearchDelegate {
  String selectedResult = "";
  List<String> recentList = [];

  // List<String> recentList = ["Text 4", "Text 3"];

  // final List<String> listMatching;
  // SearchUsers(this.listMatching);

  final List<String>? listMatching = [];
  SearchUsers();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO add this navigator go to chat with user
    // return Container(
    //   child: Center(
    //     child: Text(selectedResult),
    //   ),
    // );

    print("selectedResult $query");
    final listResults = [];

    return FutureBuilder<List<FindedUser?>?>(
      future: Provider.of<MessengerProvider>(context, listen: false)
          .usersSearch(query),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          final findedUser = snapshot.data;

          return ListView.builder(
            itemCount: findedUser!.length,
            itemBuilder: (ctx, i) {
              return ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  // Navigator.of(context).pushNamed(
                  //   ChatScreen.routeName,
                  //   arguments: findedUser[i]!.uid,
                  // );
                   Navigator.of(context).pushNamed(
                    ProfileScreen.routeName,
                    arguments: findedUser[i]!.uid
                  );


                },
                leading: findedUser[i]!.imageProfileUrl != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(
                          findedUser[i]!.imageProfileUrl!,
                        ),
                      )
                    : CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onSurface,
                        child: const Icon(Icons.person),
                      ),
                title: Text(findedUser[i]!.login),
                subtitle: Text(findedUser[i]!.fullName),
              );
            },
          );
        }

        return Center(
          child: Text(
            "No results",
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionList = [];

    if (query.isEmpty) {
      suggestionList = recentList;
    }

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            suggestionList[index],
          ),
          leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
          onTap: () {
            selectedResult = suggestionList[index];
            showResults(context);
          },
        );
      },
    );
  }
}
