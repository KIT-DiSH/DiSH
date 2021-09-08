// 仮のデータ構造
class User {
  final String userId, userName, profileText, iconImageUrl;
  final int followCount, followerCount, postCount;

  User({
    required this.userId,
    required this.userName,
    required this.profileText,
    required this.iconImageUrl,
    required this.followCount,
    required this.followerCount,
    required this.postCount,
  });
}

final testUser = User(
  userId: "TestUserName",
  userName: "苗字 名前",
  profileText:
      "テキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキスト",
  iconImageUrl:
      "https://i.pinimg.com/474x/9b/47/a0/9b47a023caf29f113237d61170f34ad9.jpg",
  followCount: 807,
  followerCount: 1580,
  postCount: 4,
);
