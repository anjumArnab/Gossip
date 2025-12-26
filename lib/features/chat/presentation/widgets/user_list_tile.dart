import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/routes.dart';

class UserListTile extends StatelessWidget {
  final String userId;
  final String createdAt;

  const UserListTile({
    super.key,
    required this.userId,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          userId.substring(0, 2).toUpperCase(),
        ),
      ),
      title: Text('User ${userId.substring(0, 8)}'),
      subtitle: Text('Joined: ${createdAt.substring(0, 10)}'),
      onTap: () {
        Get.toNamed(AppRoutes.chat, arguments: userId);
      },
    );
  }
}
