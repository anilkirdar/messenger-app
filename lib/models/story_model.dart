import 'user_model.dart';

class StoryModel {
  final UserModel user;
  List? storyDetailsList;
  List? listOfUsersHaveSeen;

  StoryModel({
    required this.user,
    this.storyDetailsList,
    this.listOfUsersHaveSeen,
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user.toMap(),
      'storyDetailsList': storyDetailsList ?? [],
      'listOfUsersHaveSeen': listOfUsersHaveSeen ?? [],
    };
  }

  StoryModel.fromMap(Map<String, dynamic> map)
      : user = UserModel.fromMap(map['user']),
        listOfUsersHaveSeen = map['listOfUsersHaveSeen'],
        storyDetailsList = map['storyDetailsList'];

  @override
  String toString() {
    return 'StoryModel(userID: ${user.userID}, storyDetailsList: $storyDetailsList';
  }
}
