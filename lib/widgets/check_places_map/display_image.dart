import 'package:dish/models/User.dart';
import 'package:dish/screens/display_posts_screen.dart';
import 'package:flutter/material.dart';

class DisplayImage extends StatelessWidget {
  const DisplayImage({
    Key? key,
    required this.imagePath,
    required this.resName,
    required this.postId,
    required this.postUser,
  }) : super(key: key);

  final String imagePath;
  final String resName;
  final String postId;
  final User postUser;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: GestureDetector(
              onLongPress: () {
                //
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DisplayPostsScreen(
                      postId: postId,
                      user: postUser,
                    ),
                  ),
                );
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(
                              resName,
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
