import 'package:dish/models/User.dart';

class Comment {
  final User user;
  final String content, timestamp;

  Comment({
    required this.content,
    required this.user,
    required this.timestamp,
  });
}
