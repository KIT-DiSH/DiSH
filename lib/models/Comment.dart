import 'package:dish/models/User.dart';

class Comment {
  final User user;
  final String id, content, timestamp;

  Comment({
    required this.id,
    required this.content,
    required this.user,
    required this.timestamp,
  });
}
