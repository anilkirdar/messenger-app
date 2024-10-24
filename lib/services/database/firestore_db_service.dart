// ignore_for_file: avoid_print

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../locator.dart';
import '../../models/chat_model.dart';
import '../../models/message_model.dart';
import '../../models/story_model.dart';
import '../../models/user_model.dart';
import '../auth/firebase_auth_service.dart';
import 'firestore_db_service_base.dart';

class FirestoreDBService implements FirestoreDBServiceBase {
  final FirebaseFirestore _firestoreDB = FirebaseFirestore.instance;
  final FirebaseAuthService _firebaseAuthService =
      locator.get<FirebaseAuthService>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List<UserModel>? userList;
  List<StoryModel>? storyList;
  List<MessageModel>? messageList;
  final key = encrypt.Key.fromBase64('asjkdhjashdkjashdkhasjdasjkdaskj');
  final iv = IV.fromLength(16);

  int randomNumCreator() {
    int randomInt = Random().nextInt(99999);
    return randomInt;
  }

  @override
  Future<bool> saveUser(UserModel? user) async {
    try {
      if (user != null) {
        await _firestoreDB
            .collection('users')
            .doc(user.userID)
            .set(user.toMap());

        StoryModel story = StoryModel(
          userID: user.userID,
          userName: user.email.substring(0, user.email.indexOf('@')) +
              randomNumCreator().toString(),
          profilePhotoURL:
              'https://firebasestorage.googleapis.com/v0/b/messenger-app-8556c.appspot.com/o/blank-profile-picture.png?alt=media&token=c80dcaf1-63ed-43ba-9bf0-fba3e9800501',
        );

        await _firestoreDB
            .collection('stories')
            .doc(user.userID)
            .set(story.toMap());

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
  Future<void> updateUserPass(
      {required String userID, required String newPass}) async {
    try {
      await _firestoreDB.collection('users').doc(userID).update({
        'updatedAt': FieldValue.serverTimestamp(),
      });

      User authUser = FirebaseAuth.instance.currentUser!;
      authUser.updatePassword(newPass);
    } catch (e) {
      print('FIRESTOREDBSERVICE updateUserPass ERROR: $e');
    }
  }

  @override
  Future<bool> deleteUser({required UserModel currentUser}) async {
    try {
      await _firestoreDB.collection('users').doc(currentUser.userID).delete();
      await _firestoreDB.collection('server').doc(currentUser.userID).delete();
      await _firestoreDB.collection('stories').doc(currentUser.userID).delete();
      await _firestoreDB
          .collection('chats')
          .where('currentUser', isEqualTo: currentUser.toMap())
          .get()
          .then(
        (querySnapshot) {
          for (DocumentSnapshot docSnapshot in querySnapshot.docs) {
            docSnapshot.reference.delete();
          }
        },
      );

      await _firebaseAuth.currentUser!.delete();
      await _firebaseAuthService.signOut();
      return true;
    } catch (e) {
      print('FIRESTOREDBSERVICE deleteUser ERROR: $e');
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

        await _firestoreDB.collection('stories').doc(userID).update({
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
  Future<void> addStory(
      {required String userID,
      required String storyPhotoUrl,
      required ValueChanged<bool> resultCallBack}) async {
    try {
      var docSnapshot =
          await _firestoreDB.collection('stories').doc(userID).get();
      StoryModel story = StoryModel.fromMap(docSnapshot.data()!);
      story.storyPhotoUrlList!.add(storyPhotoUrl);

      await _firestoreDB
          .collection('stories')
          .doc(story.userID)
          .set(story.toMap(), SetOptions(merge: true));
      resultCallBack(true);
    } catch (e) {
      resultCallBack(false);
      print('FIRESTOREDBSERVICE addStory ERROR: $e');
    }
  }

  @override
  Future<List<StoryModel>> getStories(
      {required String userID,
      required int countOfWillBeFetchedStoryCount,
      required UserModel currentUser}) async {
    List<StoryModel> listWillBeAdded = [];
    late QuerySnapshot querySnapshot;

    if (storyList == null) {
      querySnapshot = await _firestoreDB
          .collection('stories')
          .where('storyPhotoUrlList', isNotEqualTo: [])
          .limit(countOfWillBeFetchedStoryCount)
          .get();
    } else {
      querySnapshot = await _firestoreDB
          .collection('users')
          .startAfter([userID])
          .where('storyPhotoUrlList', isNotEqualTo: [])
          .limit(countOfWillBeFetchedStoryCount)
          .get();
    }

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      QueryDocumentSnapshot storyDoc = querySnapshot.docs[i];
      Map<String, dynamic> storyObject =
          storyDoc.data() as Map<String, dynamic>;

      StoryModel storyFromDB = StoryModel.fromMap(storyObject);
      bool hasInStoryList = findFromStoryList(storyFromDB.userID);

      if (!hasInStoryList) {
        if (storyFromDB.userID == currentUser.userID) {
          listWillBeAdded.insert(0, storyFromDB);
        } else {
          listWillBeAdded.insert(i, storyFromDB);
        }
        // if (storyFromDB.userID == currentUserID) {
        //   listWillBeAdded.insert(0, storyFromDB);
        // } else {
        // }
      }
    }
    if (!findFromStoryList(currentUser.userID)) {
      StoryModel story = StoryModel(
          userID: currentUser.userID,
          userName: currentUser.userName!,
          profilePhotoURL: currentUser.profilePhotoURL!,
          createdAt: currentUser.createdAt,
          storyPhotoUrlList: []);

      listWillBeAdded.insert(0, story);
    }

    if (storyList == null) {
      storyList = [];
      storyList!.addAll(listWillBeAdded);
    } else {
      storyList!.addAll(listWillBeAdded);
    }

    return storyList!;
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
      bool hasInUserList = findFromUserList(userFromDB.userID);

      if (userFromDB.userID != user.userID && !hasInUserList) {
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

      messageObject.update(
        'message',
        (value) => decryptMessage(encryptedMessage: messageObject['message']),
      );
      MessageModel messageFromDB = MessageModel.fromMap(messageObject);
      debugPrint('WILL ADDED MESSAGE: $messageFromDB');
      bool hasInMessageList = findFromMessageList(messageFromDB.messageID!);

      if (!hasInMessageList) {
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
      messageMap.update(
        'message',
        (value) => encryptMessage(message: message.message),
      );
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
  Future<Stream<List<ChatModel>>> getChats(
      {required UserModel currentUser,
      required int countOfWillBeFetchedChatCount}) async {
    try {
      DateTime messageLastSeenAt =
          await fetchMessageTime(userID: currentUser.userID);

      var snapshot = _firestoreDB
          .collection('chats')
          .where('currentUser', isEqualTo: currentUser.toMap())
          .orderBy('createdAt', descending: true)
          .limit(countOfWillBeFetchedChatCount)
          .snapshots();

      return snapshot.map(
        (querySnapshot) => querySnapshot.docs.map(
          (queryDocSnapshot) {
            ChatModel chat = ChatModel.fromMap(queryDocSnapshot.data());
            Duration timeDifference =
                messageLastSeenAt.difference(chat.createdAt!.toDate());
            timeago.setLocaleMessages('tr', timeago.TrMessages());
            chat.messageLastSeenAt = timeago.format(messageLastSeenAt.subtract(
                timeDifference)); // türkçeleştirmek için locale parametresini kullan 'tr' gibi

            return chat;
          },
        ).toList(),
      );
    } catch (e) {
      print('FIRESTOREDBSERVICE getChats ERROR: $e');
      return Stream.empty();
    }
  }

  bool findFromStoryList(String userID) {
    if (storyList != null) {
      for (var i = 0; i < storyList!.length; i++) {
        if (storyList![i].userID == userID) {
          return true;
        }
      }
    }

    return false;
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
  Future<DateTime> fetchMessageTime(
      {required String userID, bool isStory = false}) async {
    if (!isStory) {
      await _firestoreDB
          .collection('server')
          .doc(userID)
          .set({'messageTimer': FieldValue.serverTimestamp()});
    } else {
      await _firestoreDB
          .collection('server')
          .doc(userID)
          .set({'storyTimer': FieldValue.serverTimestamp()});
    }

    var fetchedMap = await _firestoreDB.collection('server').doc(userID).get();
    Timestamp fetchedDate = isStory
        ? fetchedMap.data()!['storyTimer']
        : fetchedMap.data()!['messageTimer'];

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

  String encryptMessage({required String message}) {
    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(message, iv: iv);
    return encrypted.base64;
  }

  String decryptMessage({required String encryptedMessage}) {
    final encrypter = Encrypter(AES(key));

    final decrypted = encrypter
        .decrypt(encrypt.Encrypted.fromBase64(encryptedMessage), iv: iv);
    return decrypted;
  }
}
