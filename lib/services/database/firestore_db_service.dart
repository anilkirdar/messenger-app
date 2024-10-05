// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../models/chat_model.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';
import 'database_service_base.dart';

class FirestoreDBService implements DBServiceBase {
  final FirebaseFirestore _firestoreDB = FirebaseFirestore.instance;
  List<UserModel>? userList;
  List<MessageModel>? messageList;

  @override
  Future<bool> saveUser(UserModel? user) async {
    try {
      if (user != null) {
        await _firestoreDB
            .collection('users')
            .doc(user.userID)
            .set(user.toMap());
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('FIRESTOREDBSERVICE saveUser ERROR: $e');
      return false;
    }
  }

  @override
  Future<bool> updateUserName(
      {required String userID,
      required String newUserName,
      required ValueChanged<bool> resultCallBack}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> users = await _firestoreDB
          .collection('users')
          .where('userName', isEqualTo: newUserName)
          .get();

      if (users.docs.isEmpty) {
        await _firestoreDB.collection('users').doc(userID).update({
          'userName': newUserName,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        resultCallBack(true);
        return true;
      } else {
        resultCallBack(false);
        return false;
      }
    } catch (e) {
      print('FIRESTOREDBSERVICE updateUserName ERROR: $e');
      return false;
    }
  }

  @override
  Future<bool> updateUserProfilePhoto(
      {required String userID, required String? newProfilePhotoURL}) async {
    try {
      if (newProfilePhotoURL != null) {
        await _firestoreDB.collection('users').doc(userID).update({
          'profilePhotoURL': newProfilePhotoURL,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('FIRESTOREDBSERVICE updateUserProfilePhoto ERROR: $e');
      return false;
    }
  }

  @override
  Future<UserModel> readUser(String userID) async {
    DocumentSnapshot userSnapshot =
        await _firestoreDB.collection('users').doc(userID).get();
    Map<String, dynamic> userData =
        userSnapshot.data()! as Map<String, dynamic>;
    return UserModel.fromMap(userData);
  }

  @override
  Future<List<UserModel>> getUsers(
      {required UserModel user,
      required int countOfWillBeFetchedUserCount}) async {
    List<UserModel> listWillBeAdded = [];
    late QuerySnapshot querySnapshot;

    if (userList == null) {
      querySnapshot = await _firestoreDB
          .collection('users')
          .orderBy('userName')
          .limit(countOfWillBeFetchedUserCount)
          .get();
    } else {
      querySnapshot = await _firestoreDB
          .collection('users')
          .orderBy('userName')
          .startAfter([user.userName])
          .limit(countOfWillBeFetchedUserCount)
          .get();
    }

    for (QueryDocumentSnapshot userDoc in querySnapshot.docs) {
      Map<String, dynamic> userObject = userDoc.data() as Map<String, dynamic>;
      UserModel userFromDB = UserModel.fromMap(userObject);
      bool userFromUserList = findFromUserList(userFromDB.userID);

      if (userFromDB.userID != user.userID && !userFromUserList) {
        listWillBeAdded.add(userFromDB);
      }
    }

    if (userList == null) {
      userList = [];
      userList!.addAll(listWillBeAdded);
    } else {
      userList!.addAll(listWillBeAdded);
    }

    return userList!;
  }

  @override
  Future<List<MessageModel>> getMessages(
      {required String currentUserID,
      required String otherUserID,
      MessageModel? message,
      required int countOfWillBeFetchedMessageCount,
      required bool isInitFunction}) async {
    List<MessageModel> listWillBeAdded = [];
    late QuerySnapshot querySnapshot;

    if (isInitFunction) {
      messageList = null;
      querySnapshot = await _firestoreDB
          .collection('chats')
          .doc('$currentUserID--$otherUserID')
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .limit(countOfWillBeFetchedMessageCount)
          .get();
    } else {
      querySnapshot = await _firestoreDB
          .collection('chats')
          .doc('$currentUserID--$otherUserID')
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .startAfter([message!.createdAt])
          .limit(countOfWillBeFetchedMessageCount)
          .get();
    }

    for (QueryDocumentSnapshot messageDoc in querySnapshot.docs) {
      Map<String, dynamic> messageObject =
          messageDoc.data() as Map<String, dynamic>;
      MessageModel messageFromDB = MessageModel.fromMap(messageObject);
      bool messageFromMessageList =
          findFromMessageList(messageFromDB.messageID!);

      if (!messageFromMessageList) {
        listWillBeAdded.add(messageFromDB);
      }
    }

    if (messageList == null) {
      messageList = [];
      messageList!.addAll(listWillBeAdded);
    } else {
      messageList!.addAll(listWillBeAdded);
    }

    return messageList!;
  }

  @override
  Future<bool> saveChatMessage(
      {required MessageModel message,
      required ValueChanged<bool> resultCallBack}) async {
    try {
      String messageID = _firestoreDB.collection('chats').doc().id;
      String currentUserDocID =
          '${message.fromWho.userID}--${message.toWho.userID}';
      String otherUserDocID =
          '${message.toWho.userID}--${message.fromWho.userID}';

      Map<String, dynamic> messageMap = message.toMap();
      messageMap.addEntries({'messageID': messageID}.entries);

      await _firestoreDB
          .collection('chats')
          .doc(currentUserDocID)
          .collection('messages')
          .doc(messageID)
          .set(messageMap);

      await _firestoreDB.collection('chats').doc(currentUserDocID).set({
        'currentUser': message.fromWho.toMap(),
        'otherUser': message.toWho.toMap(),
        'lastMessage': message.message,
        'lastMessageFromWho': 'me',
        'itBeenSeen': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      messageMap.update('isFromMe', (value) => false);

      await _firestoreDB
          .collection('chats')
          .doc(otherUserDocID)
          .collection('messages')
          .doc(messageID)
          .set(messageMap);

      await _firestoreDB.collection('chats').doc(otherUserDocID).set({
        'currentUser': message.toWho.toMap(),
        'otherUser': message.fromWho.toMap(),
        'lastMessage': message.message,
        'lastMessageFromWho': message.fromWho.userName,
        'itBeenSeen': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      resultCallBack(true);
      return true;
    } catch (e) {
      print('FIRESTOREDBSERVICE saveChatMessage ERROR: $e');
      return false;
    }
  }

  @override
  Future<List<ChatModel>> getChats({required UserModel currentUser}) async {
    try {
      DateTime messageLastSeenAt =
          await fetchMessageTime(userID: currentUser.userID);

      List<ChatModel> chatList = [];

      var querySnapshot = await _firestoreDB
          .collection('chats')
          .where('currentUser', isEqualTo: currentUser.toMap())
          .orderBy('createdAt', descending: true)
          .get();

      for (var chatElement in querySnapshot.docs) {
        ChatModel chat = ChatModel.fromMap(chatElement.data());

        Duration timeDifference =
            messageLastSeenAt.difference(chat.createdAt!.toDate());
        timeago.setLocaleMessages('tr', timeago.TrMessages());
        chat.messageLastSeenAt = timeago.format(messageLastSeenAt.subtract(
            timeDifference)); // türkçeleştirmek için locale parametresini kullan 'tr' gibi

        chatList.add(chat);
      }

      return chatList;
    } catch (e) {
      print('FIRESTOREDBSERVICE getMessages ERROR: $e');
      return [];
    }
  }

  bool findFromUserList(String userID) {
    if (userList != null) {
      for (var i = 0; i < userList!.length; i++) {
        if (userList![i].userID == userID) {
          return true;
        }
      }
    }

    return false;
  }

  bool findFromMessageList(String messageID) {
    if (messageList != null) {
      for (var i = 0; i < messageList!.length; i++) {
        if (messageList![i].messageID == messageID) {
          return true;
        }
      }
    }

    return false;
  }

  @override
  Future<DateTime> fetchMessageTime({required String userID}) async {
    await _firestoreDB
        .collection('server')
        .doc(userID)
        .set({'time': FieldValue.serverTimestamp()});

    var fetchedMap = await _firestoreDB.collection('server').doc(userID).get();
    Timestamp fetchedDate = fetchedMap.data()!['time'];

    return fetchedDate.toDate();
  }

  @override
  Stream<List<MessageModel?>> messageListener(
      {required String currentUserID, required String otherUserID}) {
    var snapshot = _firestoreDB
        .collection('chats')
        .doc('$currentUserID--$otherUserID')
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots();

    return snapshot.map(
      (querySnapshot) => querySnapshot.docs.map(
        (queryDocSnapshot) {
          MessageModel message = MessageModel.fromMap(queryDocSnapshot.data());
          bool messageFromMessageList = findFromMessageList(message.messageID!);

          if (!messageFromMessageList && message.createdAt != null) {
            return message;
          }
        },
      ).toList(),
    );
  }
}
