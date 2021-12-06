import 'package:flutter/material.dart';

import 'package:dish/models/User.dart';
import 'package:dish/screens/profile_screen.dart';
import 'package:dish/configs/constant_colors.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    Key? key,
    required this.user,
    required this.openFooter,
    required this.closeFooter,
  }) : super(key: key);

  final User user;
  final VoidCallback openFooter;
  final VoidCallback closeFooter;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ProfileScreen(
                    uid: user.uid!,
                    openFooter: openFooter,
                    closeFooter: closeFooter,
                  )),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 12,
        ),
        decoration: BoxDecoration(color: Color(0xFFFBFBFB)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColor.kPinkColor,
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  child: Image.network(
                    user.iconImageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.userName,
                  style: TextStyle(
                    color: AppColor.kPrimaryTextColor,
                    fontSize: 12,
                  ),
                ),
                Text(
                  user.userId,
                  style: TextStyle(
                    color: AppColor.kPrimaryTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
