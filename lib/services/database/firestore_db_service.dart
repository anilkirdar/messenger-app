// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:encrypt/encrypt.dart' as encrypt;
// import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';
// import 'package:timeago/timeago.dart' as timeago;
import '../../models/chat_model.dart';
import '../../models/message_model.dart';
import '../../models/story_model.dart';
import '../../models/user_model.dart';
import 'firestore_db_service_base.dart';

class FirestoreDBService implements FirestoreDBServiceBase {
  final FirebaseFirestore _firestoreDB = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  List<UserModel>? userList;
  List<StoryModel>? storyList;
  List<MessageModel>? messageList;
  // final encrypt.Key key = encrypt.Key.fromUtf8('jjd3PwXGErrybXhgRo4LAg==');
  // final encrypt.IV iv = encrypt.IV.fromLength(16);
  Codec<String, String> stringToBase64 = utf8.fuse(base64);

  @override
  void setNull() {
    userList = null;
    storyList = null;
    messageList = null;
  }

  @override
  Future<bool> saveUser({required UserModel? user, String? pass}) async {
    try {
      setNull();

      if (user != null) {
        Map<String, dynamic> userMap = user.toMap();
        if (pass != null || pass != '') {
          userMap.update(
            'pass',
            (value) {
              return pass;
            },
          );
        } else {
          userMap.update('signType', (value) => 'google');
        }

        await _firestoreDB.collection('users').doc(user.userID).set({
          'signType': userMap['signType'],
          'userID': userMap['userID'],
          'email': encryptString(userMap['email']),
          'pass': encryptString(userMap['pass']),
          'userName': encryptString(userMap['userName'] ??
              (userMap['email'] as String)
                      .substring(0, (userMap['email'] as String).indexOf('@')) +
                  randomNumCreator().toString()),
          'profilePhotoURL': userMap['profilePhotoURL'] ??
              'https://firebasestorage.googleapis.com/v0/b/messenger-app-8556c.appspot.com/o/blank-profile-picture.png?alt=media&token=c80dcaf1-63ed-43ba-9bf0-fba3e9800501',
          'createdAt': userMap['createdAt'] ?? FieldValue.serverTimestamp(),
          'updatedAt': userMap['updatedAt'] ?? FieldValue.serverTimestamp(),
        });

        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('FIRESTOREDBSERVICE saveUser ERROR: $e');
      return false;
    }
  }

  int randomNumCreator() {
    int randomInt = Random().nextInt(99999);
    return randomInt;
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
          'userName': encryptString(newUserName),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        resultCallBack(true);
        return true;
      } else {
        resultCallBack(false);
        return false;
      }
    } catch (e) {
      debugPrint('FIRESTOREDBSERVICE updateUserName ERROR: $e');
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
      debugPrint('FIRESTOREDBSERVICE updateUserPass ERROR: $e');
    }
  }

  @override
  Future<bool> deleteUser({required UserModel currentUser}) async {
    try {
      await _firestoreDB.collection('users').doc(currentUser.userID).delete();
      await _firestoreDB.collection('server').doc(currentUser.userID).delete();
      // await _firestoreDB.collection('stories').doc(currentUser.userID).delete();
      await _firestoreDB
          .collection('chats')
          .where('fromWho.userID', isEqualTo: currentUser.toMap())
          .get()
          .then(
        (querySnapshot) async {
          for (DocumentSnapshot docSnapshot in querySnapshot.docs) {
            await docSnapshot.reference.delete();
          }
        },
      );

      await _firebaseAuth.currentUser!.delete();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        bool result = await _reauthenticateAndDelete(currentUser: currentUser);
        return result;
      } else {
        debugPrint(
            'FIRESTOREDBSERVICE deleteUser FirebaseAuthException ERROR: $e');
        return false;
      }
    } catch (e) {
      debugPrint('FIRESTOREDBSERVICE deleteUser ERROR: $e');
      return false;
    }
  }

  @override
  Future<bool> updateUserProfilePhoto(
      {required String userID, String? newProfilePhotoURL}) async {
    try {
      if (newProfilePhotoURL != null) {
        await _firestoreDB.collection('users').doc(userID).update({
          'profilePhotoURL': newProfilePhotoURL,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        await _firestoreDB
            .collection('chats')
            .where('fromWho.userID', isEqualTo: userID)
            .get()
            .then(
          (querySnapshot) {
            for (DocumentSnapshot docSnapshot in querySnapshot.docs) {
              docSnapshot.reference.update({
                'toWho': {
                  {
                    'profilePhotoURL': newProfilePhotoURL,
                    'updatedAt': FieldValue.serverTimestamp(),
                  }
                }
              });
            }
          },
        );

        // await _firestoreDB.collection('stories').doc(userID).update({
        //   'profilePhotoURL': newProfilePhotoURL,
        //   'updatedAt': FieldValue.serverTimestamp(),
        // });

        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('FIRESTOREDBSERVICE updateUserProfilePhoto ERROR: $e');
      return false;
    }
  }

  @override
  Future<UserModel> readUser(String userID) async {
    DocumentSnapshot userSnapshot =
        await _firestoreDB.collection('users').doc(userID).get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    UserModel user = UserModel.fromMap(userData);
    user.email = decryptMessage(user.email);
    user.userName = decryptMessage(user.userName!);
    return user;
  }

  @override
  Future<void> addDefaultStorySettingsToUser({required UserModel user}) async {
    StoryModel story = StoryModel(user: user);

    await _firestoreDB
        .collection('stories')
        .doc(user.userID)
        .set(story.toMap());
  }

  @override
  Future<void> addStory(
      {required String userID,
      required String? storyPhotoUrl,
      required String fileName}) async {
    try {
      if (storyPhotoUrl != null) {
        var docSnapshot =
            await _firestoreDB.collection('stories').doc(userID).get();
        StoryModel story = StoryModel.fromMap(docSnapshot.data()!);

        var palleteGenerator = await PaletteGenerator.fromImageProvider(
          NetworkImage(storyPhotoUrl),
        );

        print('DOMINANT COLOR SPACE: ${palleteGenerator.dominantColor?.color}');

        story.listOfUsersHaveSeen = [];
        story.storyDetailsList!.add({
          'storyPhotoUrl': storyPhotoUrl,
          'storyPhotoName': fileName,
          'dominantColor': palleteGenerator.dominantColor?.color.value,
          'createdAt': DateTime.now(),
        });

        await _firestoreDB
            .collection('stories')
            .doc(story.user.userID)
            .set(story.toMap(), SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint('FIRESTOREDBSERVICE addStory ERROR: $e');
    }
  }

  @override
  Future<List<StoryModel>> getStories(
      {required String userID,
      required int countOfWillBeFetchedStoryCount,
      required UserModel currentUser}) async {
    try {
      List<StoryModel> listWillBeAdded = [];
      late QuerySnapshot querySnapshot;
      bool hasAnyChanges = false;

      if (storyList == null) {
        querySnapshot = await _firestoreDB
            .collection('stories')
            .where('storyDetailsList', isNotEqualTo: [])
            .orderBy('user.userName')
            .limit(countOfWillBeFetchedStoryCount)
            .get();
      } else {
        querySnapshot = await _firestoreDB
            .collection('stories')
            .startAfter([userID])
            .where('storyDetailsList', isNotEqualTo: [])
            .orderBy('user.userName')
            .limit(countOfWillBeFetchedStoryCount)
            .get();
      }

      for (var i = 0; i < querySnapshot.docs.length; i++) {
        QueryDocumentSnapshot storyDoc = querySnapshot.docs[i];
        Map<String, dynamic> storyObject =
            storyDoc.data() as Map<String, dynamic>;

        StoryModel storyFromDB = StoryModel.fromMap(storyObject);

        for (var i = 0; i < storyFromDB.storyDetailsList!.length; i++) {
          Map<String, dynamic> currentStoryDetails =
              storyFromDB.storyDetailsList![i];

          if (getTimeDifference(currentStoryDetails['createdAt']) >= 24) {
            storyFromDB.storyDetailsList!.removeAt(i);
            await _firebaseStorage
                .ref()
                .child(storyFromDB.user.userID)
                .child('story-photos')
                .child(currentStoryDetails['storyPhotoName'])
                .delete();

            hasAnyChanges = true;
          } else {
            hasAnyChanges = false;
          }
        }

        if (hasAnyChanges) {
          await _firestoreDB
              .collection('stories')
              .doc(storyFromDB.user.userID)
              .update({'storyDetailsList': storyFromDB.storyDetailsList});
        }

        bool hasInStoryList = findFromStoryList(storyFromDB.user.userID);

        if (!hasInStoryList) {
          if (storyFromDB.user.userID == currentUser.userID) {
            listWillBeAdded.insert(0, storyFromDB);
          } else {
            if (storyFromDB.storyDetailsList!.isNotEmpty) {
              listWillBeAdded.add(storyFromDB);
            }
          }
        }
      }

      if (storyList == null) {
        storyList = [];
        storyList!.addAll(listWillBeAdded);
      } else {
        storyList!.addAll(listWillBeAdded);
      }

      if (!findFromStoryList(currentUser.userID)) {
        StoryModel story = StoryModel(user: currentUser, storyDetailsList: []);

        storyList!.insert(0, story);
      }

      return storyList!;
    } catch (e) {
      debugPrint('FIRESTOREDBSERVICE getStories ERROR: $e');
      return [];
    }
  }

  @override
  Future<List<UserModel>> getUsers(
      {required UserModel currentUser,
      required UserModel user,
      required int countOfWillBeFetchedUserCount}) async {
    try {
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
        Map<String, dynamic> userObject =
            userDoc.data() as Map<String, dynamic>;
        UserModel userFromDB = UserModel.fromMap(userObject);
        userFromDB.email = decryptMessage(userFromDB.email);
        userFromDB.userName = decryptMessage(userFromDB.userName!);

        bool hasInUserList = findFromUserList(userFromDB.userID);

        if (userFromDB.userID != currentUser.userID && !hasInUserList) {
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
    } catch (e) {
      debugPrint('FIRESTOREDBSERVICE getUsers ERROR: $e');
      return [];
    }
  }

  @override
  Future<List<MessageModel>> getMessages(
      {required String currentUserID,
      required String otherUserID,
      MessageModel? message,
      required int countOfWillBeFetchedMessageCount,
      required bool isInitFunction}) async {
    try {
      List<MessageModel> listWillBeAdded = [];
      late QuerySnapshot querySnapshot;

      if (isInitFunction) {
        messageList = null;
        querySnapshot = await _firestoreDB
            .collection('chats')
            .doc('$currentUserID--$otherUserID')
            .collection('messages')
            .orderBy('createdAt', descending: false)
            .limit(countOfWillBeFetchedMessageCount)
            .get();
      } else {
        querySnapshot = await _firestoreDB
            .collection('chats')
            .doc('$currentUserID--$otherUserID')
            .collection('messages')
            .orderBy('createdAt', descending: false)
            .startAfter([message!.createdAt])
            .limit(countOfWillBeFetchedMessageCount)
            .get();
      }

      for (QueryDocumentSnapshot messageDoc in querySnapshot.docs) {
        Map<String, dynamic> messageObject =
            messageDoc.data() as Map<String, dynamic>;

        // messageObject.update(
        //   'message',
        //   (value) => decryptMessage(messageObject['message']),
        // );

        MessageModel messageFromDB = MessageModel.fromMap(messageObject);
        messageFromDB.message = decryptMessage(messageFromDB.message);

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
    } catch (e) {
      debugPrint('FIRESTOREDBSERVICE getMessages ERROR: $e');
      return [];
    }
  }

  @override
  Future<bool?> saveChatMessage(
      {required MessageModel message,
      required UserModel currentUser,
      required UserModel otherUser,
      required ValueChanged<bool> resultCallBack}) async {
    try {
      String messageID = _firestoreDB.collection('chats').doc().id;
      String currentUserDocID = '${currentUser.userID}--${otherUser.userID}';
      String otherUserDocID = '${otherUser.userID}--${currentUser.userID}';

      Map<String, dynamic> messageMap = message.toMap();

      messageMap['message'] = encryptString(messageMap['message']);
      messageMap['createdAt'] = FieldValue.serverTimestamp();
      messageMap.addEntries({'messageID': messageID}.entries);

      Map<String, dynamic> currentUserMap = currentUser.toMap();
      currentUserMap['userName'] = encryptString(currentUserMap['userName']);
      currentUserMap['email'] = encryptString(currentUserMap['email']);

      Map<String, dynamic> otherUserMap = otherUser.toMap();
      otherUserMap['userName'] = encryptString(otherUserMap['userName']);
      otherUserMap['email'] = encryptString(otherUserMap['email']);

      await _firestoreDB
          .collection('chats')
          .doc(currentUserDocID)
          .collection('messages')
          .doc(messageID)
          .set({
        'messageID': messageID,
        'message': messageMap['message'],
        'isFromMe': messageMap['isFromMe'],
        'itBeenSeen': false,
        'createdAt': messageMap['createdAt'],
      });

      await _firestoreDB.collection('chats').doc(currentUserDocID).set({
        'fromWho': currentUserMap,
        'toWho': otherUserMap,
        'lastMessage': messageMap,
        'lastMessageFromWho': encryptString('me'),
      });

      messageMap.update('isFromMe', (value) => false);

      await _firestoreDB
          .collection('chats')
          .doc(otherUserDocID)
          .collection('messages')
          .doc(messageID)
          .set({
        'messageID': messageID,
        'message': messageMap['message'],
        'isFromMe': messageMap['isFromMe'],
        'itBeenSeen': false,
        'createdAt': messageMap['createdAt'],
      });

      await _firestoreDB.collection('chats').doc(otherUserDocID).set({
        'fromWho': otherUserMap,
        'toWho': currentUserMap,
        'lastMessage': messageMap,
        'lastMessageFromWho': encryptString(otherUser.userName!),
      });

      resultCallBack(true);
      return true;
    } catch (e) {
      debugPrint('FIRESTOREDBSERVICE saveChatMessage ERROR: $e');
      resultCallBack(false);
      return false;
    }
  }

  @override
  Future<Stream<List<ChatModel>>> getChatListStream(
      {required String currentUserID,
      required int countOfWillBeFetchedChatCount}) async {
    try {
      DateTime serverTime = await fetchTime(userID: currentUserID);

      var snapshot = _firestoreDB
          .collection('chats')
          .where('fromWho.userID', isEqualTo: currentUserID)
          .orderBy('lastMessage.createdAt', descending: true)
          .limit(countOfWillBeFetchedChatCount)
          .snapshots();

      var subscription = snapshot.map(
        (querySnapshot) => querySnapshot.docs.map(
          (queryDocSnapshot) {
            ChatModel chat = ChatModel.fromMap(queryDocSnapshot.data());
            chat.fromWho.userName = decryptMessage(chat.fromWho.userName!);
            chat.toWho.userName = decryptMessage(chat.toWho.userName!);
            chat.fromWho.email = decryptMessage(chat.fromWho.email);
            chat.toWho.email = decryptMessage(chat.toWho.email);
            chat.lastMessage.message = decryptMessage(chat.lastMessage.message);
            chat.lastMessageFromWho = decryptMessage(chat.lastMessageFromWho);

            Duration timeDifference = serverTime.difference(
                chat.lastMessage.createdAt?.toDate() ?? DateTime.now());
            // timeago.setLocaleMessages('tr', timeago.TrMessages());
            // chat.lastMessageSentAt = timeago.format(
            //   serverTime.subtract(timeDifference),
            // ); // türkçeleştirmek için locale parametresini kullan 'tr' gibi
            chat.lastMessageSentAt = getlastMessageSentAt(
                chat.lastMessage.createdAt, timeDifference);

            return chat;
          },
        ).toList(),
      );

      return subscription;
    } catch (e) {
      debugPrint('FIRESTOREDBSERVICE getChatListStream ERROR: $e');
      return Stream.empty();
    }
  }

  bool findFromStoryList(String userID) {
    if (storyList != null) {
      for (var i = 0; i < storyList!.length; i++) {
        if (storyList![i].user.userID == userID) {
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
  Future<DateTime> fetchTime(
      {required String userID, bool isStory = false}) async {
    if (isStory) {
      await _firestoreDB
          .collection('server')
          .doc(userID)
          .set({'storyTimer': FieldValue.serverTimestamp()});
    } else {
      await _firestoreDB
          .collection('server')
          .doc(userID)
          .set({'messageTimer': FieldValue.serverTimestamp()});
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
          Map<String, dynamic> messageMap = queryDocSnapshot.data();

          MessageModel message = MessageModel.fromMap(messageMap);
          message.message = decryptMessage(message.message);
          message.createdAt = message.createdAt ?? Timestamp.now();

          bool messageHasInMessageList =
              findFromMessageList(message.messageID!);

          if (!messageHasInMessageList) {
            return message;
          }
        },
      ).toList(),
    );
  }

  @override
  Stream<List<dynamic>?> currentUserStoryListener(
      {required String currentUserID}) {
    try {
      var snapshot =
          _firestoreDB.collection('stories').doc(currentUserID).snapshots();

      return snapshot.map(
        (queryDocSnapshot) {
          Map<String, dynamic> storyMap = queryDocSnapshot.data()!;
          StoryModel storyFromDB = StoryModel.fromMap(storyMap);

          return storyFromDB.storyDetailsList;
        },
      );
    } catch (e) {
      print('FIRESTOREDBSERVICE currentUserStoryListener ERROR: $e');
      return Stream.empty();
    }
  }

  // String encryptMessage({required String message}) {
  //   final Encrypter encrypter = encrypt.Encrypter(AES(key, padding: null));

  //   final Encrypted encrypted = encrypter.encrypt(message, iv: iv);
  //   return encrypted.base64;
  // }

  // String decryptMessage({required String encryptedBase64}) {
  //   final Encrypter encrypter = Encrypter(AES(key, padding: null));

  //   final String decrypted = encrypter
  //       .decrypt(encrypt.Encrypted.fromBase64(encryptedBase64), iv: iv);
  //   return decrypted;
  // }

  String encryptString(String a) {
    String encoded = stringToBase64.encode(a);

    return encoded;
  }

  String decryptMessage(String encryptedBase64) {
    String decoded = stringToBase64.decode(encryptedBase64);

    return decoded;
  }

  int getTimeDifference(Timestamp storyCreatedAtTimestamp) {
    DateTime currentDateTime = DateTime.now();
    DateTime storyCreatedAt = storyCreatedAtTimestamp.toDate();
    Duration timeDifference = currentDateTime.difference(storyCreatedAt);

    return timeDifference.inHours;
  }

  Future<bool> _reauthenticateAndDelete(
      {required UserModel currentUser}) async {
    try {
      if (currentUser.signType == 'google') {
        await _firebaseAuth.currentUser!
            .reauthenticateWithProvider(GoogleAuthProvider());
      } else if (currentUser.signType == 'email') {
        await _firebaseAuth.currentUser!.reauthenticateWithCredential(
            EmailAuthProvider.credential(
                email: currentUser.email, password: currentUser.pass));
      }

      await _firebaseAuth.currentUser!.delete();
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint(
          'FIRESTOREDBSERVICE _reauthenticateAndDelete FirebaseAuthException ERROR: ${e.code}');
      return false;
    } catch (e) {
      debugPrint('FIRESTOREDBSERVICE _reauthenticateAndDelete ERROR: $e');
      return false;
    }
  }

  String? getlastMessageSentAt(Timestamp? createdAt, Duration timeDifference) {
    DateTime dateTime = createdAt?.toDate() ?? DateTime.now();

    if (timeDifference.inDays == 1) {
      return 'Yesterday';
    } else if (timeDifference.inDays > 1 && timeDifference.inDays < 7) {
      String dayName = DateFormat.EEEE().format(dateTime);
      return dayName;
    } else if (timeDifference.inDays > 7) {
      return '${dateTime.month}/${dateTime.day}/${dateTime.year.toString().substring(2)}';
    } else {
      String formattedHour =
          dateTime.hour < 10 ? '0${dateTime.hour}' : dateTime.hour.toString();
      String formattedMinute = dateTime.minute < 10
          ? '0${dateTime.minute}'
          : dateTime.minute.toString();
      return '$formattedHour:$formattedMinute';
    }
  }
}
