import 'package:get/get.dart';
import 'dart:async';
import '../../../auth/domain/usecases/get_current_user.dart';
import '../../domain/entities/chat_user_entity.dart';
import '../../domain/usecases/get_users.dart';

class UsersController extends GetxController {
  final GetUsers getUsers;
  final GetCurrentUser getCurrentUser;

  UsersController(this.getUsers, this.getCurrentUser);

  List<ChatUserEntity> users = [];
  List<ChatUserEntity> displayedUsers = [];
  bool isLoading = false;
  String? errorMessage;
  StreamSubscription? _subscription;

  final int pageSize = 10;
  int currentPage = 0;

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  void loadUsers() {
    isLoading = true;
    update();

    _subscription = getUsers().listen(
      (usersList) {
        users = usersList;
        currentPage = 0;
        displayedUsers = users.take(pageSize).toList();
        isLoading = false;
        errorMessage = null;
        update();
      },
      onError: (error) {
        errorMessage = error.toString();
        isLoading = false;
        update();
      },
    );
  }

  void loadMoreUsers() {
    if (displayedUsers.length >= users.length) return;

    currentPage++;
    final endIndex = (currentPage + 1) * pageSize;
    displayedUsers = users.take(endIndex).toList();
    update();
  }

  bool get hasMore => displayedUsers.length < users.length;

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}