// 仮のデータ構造
class Post {
  final List<String> postImageUrls;
  final String postId, userId, postText, postedDate;
  final int favoCount, commentCount;

  Post({
    required this.postImageUrls,
    required this.postId,
    required this.userId,
    required this.postText,
    required this.postedDate,
    required this.favoCount,
    required this.commentCount,
  });
}

List<Post> testPosts = [
  Post(
    postImageUrls: [
      "https://www.kewpie.co.jp/mayokitchen/img/recipe/QP00012673.jpg",
    ],
    postId: "01",
    userId: "TestUserName",
    postText: "テキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキスト",
    postedDate: "10時間前",
    favoCount: 158,
    commentCount: 7,
  ),
  Post(
    postImageUrls: [
      "https://www.kewpie.co.jp/mayokitchen/img/bnr_tokushu8_sp.jpg",
    ],
    postId: "02",
    userId: "TestUserName",
    postText: "テキストテキストテキストテキスト",
    postedDate: "2日前",
    favoCount: 3,
    commentCount: 178,
  ),
  Post(
    postImageUrls: [
      "https://www.kewpie.co.jp/mayokitchen/img/recipe/QP10001493.jpg",
    ],
    postId: "03",
    userId: "TestUserName",
    postText: "テキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキスト",
    postedDate: "2020.08.01",
    favoCount: 32,
    commentCount: 0,
  ),
  Post(
    postImageUrls: [
      "https://image.delishkitchen.tv/recipe/169785602751857043/1.jpg?version=1603359542",
    ],
    postId: "04",
    userId: "TestUserName",
    postText: "テキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキスト",
    postedDate: "2020.07.03",
    favoCount: 13,
    commentCount: 8,
  ),
];
