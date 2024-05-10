import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:babmbino/screens/profile_screen.dart';
import 'package:babmbino/utils/colors.dart';
import 'package:babmbino/utils/global_variable.dart';

import '../widgets/post_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1d6b7c),
        title: Form(
          child: TextFormField(
            controller: searchController,
            decoration:
                const InputDecoration(labelText: 'Search for a user...',suffixIcon: Icon(Icons.search, color: Colors.white,),labelStyle: TextStyle(
                  color: Colors.white
                )),
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
              });
              print(_);
            },
          ),
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'username',
                    isGreaterThanOrEqualTo: searchController.text,
                  )
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            uid: (snapshot.data! as dynamic).docs[index]['uid'],
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            (snapshot.data! as dynamic).docs[index]['photoUrl'],
                          ),
                          radius: 16,
                        ),
                        title: Text(
                          (snapshot.data! as dynamic).docs[index]['username'],
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('datePublished')
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
  
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) =>
                      InkWell(
                    child:
                    CircleAvatar(
                      backgroundImage:NetworkImage(
                          (snapshot.data! as dynamic).docs[index]['postUrl']
                      ) ,
                    ),
                    onTap:() {
                      Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(
                              builder: (context) => ResponsiveAddStory(
                                    verticalScreen: AddStoryY(
                                      storyTitle: (snapshot.data! as dynamic).docs[index]['description'],
                                      profileImage: (snapshot.data! as dynamic).docs[index]['profImage'],
                                      storyBody: (snapshot.data! as dynamic).docs[index]['story'],
                                      ImageURL: (snapshot.data! as dynamic).docs[index]['photos'],
                                      scaleW: 0.8,
                                      scaleH: 0.7,
                                    ),
                                    horizontalScreen: AddStoryX(
                                      storyTitle: (snapshot.data! as dynamic).docs[index]['description'],
                                      profileImage: (snapshot.data! as dynamic).docs[index]['profImage'],
                                      storyBody: (snapshot.data! as dynamic).docs[index]['story'],
                                      ImageURL: (snapshot.data! as dynamic).docs[index]['photos'],
                                      scaleH: 1,
                                      scaleW: 0.35,
                                    ),
                                  )));
                    },
                  ),
                  staggeredTileBuilder: (index) => MediaQuery.of(context)
                              .size
                              .width >
                          webScreenSize
                      ? StaggeredTile.count(
                          (index % 7 == 0) ? 1 : 1, (index % 7 == 0) ? 1 : 1)
                      : StaggeredTile.count(
                          (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                );
              },
            ),
    );
  }
}
