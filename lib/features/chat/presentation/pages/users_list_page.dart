import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gossip/features/chat/presentation/widgets/user_list_tile.dart';
import '../../../../core/di/injection_container.dart';
import '../controllers/users_controller.dart';

class UsersListPage extends StatelessWidget {
  const UsersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(sl<UsersController>());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        automaticallyImplyLeading: false,
      ),
      body: GetBuilder<UsersController>(
        builder: (ctrl) {
          if (ctrl.isLoading && ctrl.displayedUsers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (ctrl.errorMessage != null) {
            return Center(child: Text(ctrl.errorMessage!));
          }

          if (ctrl.displayedUsers.isEmpty) {
            return const Center(child: Text('No users available'));
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (!ctrl.isLoading &&
                  ctrl.hasMore &&
                  scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                ctrl.loadMoreUsers();
              }
              return false;
            },
            child: ListView.builder(
              itemCount: ctrl.displayedUsers.length + (ctrl.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == ctrl.displayedUsers.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final user = ctrl.displayedUsers[index];
                return UserListTile(
                  userId: user.id,
                  createdAt: user.createdAt,
                );
              },
            ),
          );
        },
      ),
    );
  }
}