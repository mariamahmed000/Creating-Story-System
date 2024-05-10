import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:babmbino/screens/feed_screen.dart';
import 'package:babmbino/screens/profile_screen.dart';
import 'package:babmbino/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  //const AddPostScreen(),
  const Text('notifications'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
