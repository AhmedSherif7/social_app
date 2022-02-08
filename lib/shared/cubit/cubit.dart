import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chat_screen.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/modules/profile/profile_screen.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/cubit/states.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(BuildContext context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screen = const [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    ProfileScreen(),
  ];

  List<String> titles = const [
    'Home',
    'Chats',
    'Add Post',
    'Profile',
  ];

  void changeCurrentIndex(int index) {
    if (index == 1) {
      getUsers();
    }
    if (index == 2) {
      emit(NewPostState());
    } else {
      currentIndex = index;
      emit(BottomNavChangeState());
    }
  }

  UserModel? user;

  void getUserData() {
    emit(GetUserLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(Constants.uid!)
        .get()
        .then((value) {
      user = UserModel.fromJson(value.data()!);
      emit(GetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetUserErrorState(error.toString()));
    });
  }

  final picker = ImagePicker();
  File? profileImage;
  File? coverImage;

  Future<void> getImage({required String image}) async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      if (image == 'profile') {
        profileImage = File(pickedImage.path);
        emit(ProfileImagePickedSuccessState());
      } else if (image == 'cover') {
        coverImage = File(pickedImage.path);
        emit(CoverImagePickedSuccessState());
      } else {
        postImage = File(pickedImage.path);
        emit(PostImagePickedSuccessState());
      }
    } else {
      if (image == 'profile') {
        emit(ProfileImagePickedErrorState());
      } else if (image == 'cover') {
        emit(CoverImagePickedErrorState());
      } else {
        emit(PostImagePickedErrorState());
      }
      print('No image selected');
    }
  }

  Future uploadImage({required String path, required File image}) {
    return firebase_storage.FirebaseStorage.instance
        .ref()
        .child('$path/${Uri.file(image.path).pathSegments.last}')
        .putFile(image);
  }

  Future<String> getImageUrl(value) {
    return value.ref.getDownloadURL();
  }

  void uploadUserData({
    String? name,
    String? phone,
    String? bio,
    String? image,
    String? cover,
  }) {
    profileImage = null;
    coverImage = null;

    UserModel updatedUser = UserModel(
      uid: user!.uid,
      email: user!.email,
      name: name ?? user!.name,
      phone: phone ?? user!.phone,
      bio: bio ?? user!.bio,
      image: image ?? user!.image,
      cover: cover ?? user!.cover,
      isEmailVerified: user!.isEmailVerified,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(Constants.uid!)
        .update(updatedUser.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(UpdateUserErrorState());
    });
  }

  void updateUserData({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(UpdateUserDataLoadingState());
    if (profileImage != null && coverImage != null) {
      uploadImage(
        path: 'users',
        image: profileImage!,
      ).then((uploadedProfileImage) {
        getImageUrl(uploadedProfileImage).then((profileImageUrl) {
          uploadImage(
            path: 'users',
            image: coverImage!,
          ).then((uploadedCoverImage) {
            getImageUrl(uploadedCoverImage).then((coverImageUrl) {
              uploadUserData(
                name: name,
                phone: phone,
                bio: bio,
                image: profileImageUrl,
                cover: coverImageUrl,
              );
            }).catchError((error) {
              emit(GetCoverImageUrlErrorState());
            });
          }).catchError((error) {
            emit(UploadCoverImageErrorState());
          });
        }).catchError((error) {
          emit(GetProfileImageUrlErrorState());
        });
      }).catchError((error) {
        emit(UploadProfileImageErrorState());
      });
    } else if (profileImage != null) {
      uploadImage(
        path: 'users',
        image: profileImage!,
      ).then((uploadedProfileImage) {
        getImageUrl(uploadedProfileImage).then((profileImageUrl) {
          uploadUserData(
            name: name,
            phone: phone,
            bio: bio,
            image: profileImageUrl,
          );
        }).catchError((error) {
          emit(GetProfileImageUrlErrorState());
        });
      }).catchError((error) {
        emit(UploadProfileImageErrorState());
      });
    } else if (coverImage != null) {
      uploadImage(
        path: 'users',
        image: coverImage!,
      ).then((uploadedCoverImage) {
        getImageUrl(uploadedCoverImage).then((coverImageUrl) {
          uploadUserData(
            name: name,
            phone: phone,
            bio: bio,
            cover: coverImageUrl,
          );
        }).catchError((error) {
          emit(GetCoverImageUrlErrorState());
        });
      }).catchError((error) {
        emit(UploadCoverImageErrorState());
      });
    } else {
      uploadUserData(
        name: name,
        phone: phone,
        bio: bio,
      );
    }
  }

  File? postImage;

  void createPost({required String text, required Timestamp dateTime}) {
    emit(CreatePostLoadingState());
    if (postImage != null) {
      uploadImage(
        path: 'posts',
        image: postImage!,
      ).then((value) {
        getImageUrl(value).then((postImageUrl) {
          uploadPost(
              text: text, dateTime: dateTime, postImageUrl: postImageUrl);
        }).catchError((error) {
          emit(CreatePostErrorState());
        });
      }).catchError((error) {
        emit(CreatePostErrorState());
      });
    } else {
      uploadPost(text: text, dateTime: dateTime);
    }
  }

  void uploadPost({
    required String text,
    required Timestamp dateTime,
    String? postImageUrl,
  }) {
    PostModel post = PostModel(
      uid: user!.uid,
      text: text,
      dateTime: dateTime,
      postImage: postImageUrl ?? '',
      likes: [],
      commentsCount: 0,
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(post.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(value.id)
          .update({'postId': value.id}).then((value) {
        emit(CreatePostSuccessState());
        postImage = null;
      }).catchError((error) {
        emit(CreatePostErrorState());
      });
    }).catchError((error) {
      emit(CreatePostErrorState());
    });
  }

  void removePostImage() {
    postImage = null;
    emit(RemovePostImageState());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getPosts() {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime', descending: true)
        .snapshots();
  }

  bool isPostLiked(List<dynamic> likes) {
    return likes.any((id) => id == user!.uid);
  }

  void changeLikeState({required bool like, required String postId}) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('posts').doc(postId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      final newLikes = data['likes'] as List<dynamic>;

      if (!like) {
        newLikes.add(user!.uid!);
        transaction.update(documentReference, {'likes': newLikes});
      } else {
        newLikes.remove(user!.uid!);
        transaction.update(documentReference, {'likes': newLikes});
      }
      return newLikes;
    }).then((value) {
      emit(ChangePostLikeSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(ChangePostLikeErrorState(error.toString()));
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDataById(
      String userId) {
    return FirebaseFirestore.instance.collection('users').doc(userId).get();
  }

  String commentText = '';
  final commentController = TextEditingController();

  void changeComment(String value) {
    commentText = value;
    emit(ChangeCommentState());
  }

  void createComment({
    required String postId,
    required Timestamp timestamp,
  }) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('posts').doc(postId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      var newCommentsCount = data['commentsCount'] as int;

      newCommentsCount++;
      transaction.update(
        documentReference,
        {'commentsCount': newCommentsCount},
      );

      return newCommentsCount;
    }).then((value) {
      documentReference.collection('comments').add({
        'text': commentController.text.trim(),
        'dateTime': timestamp,
        'uid': user!.uid,
      }).then((value) {
        commentText = '';
        commentController.clear();

        emit(CreateCommentSuccessState());
      }).catchError((error) {
        emit(CreateCommentErrorState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(CreateCommentErrorState());
    });
  }

  getComments(String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('dateTime', descending: true)
        .snapshots();
  }

  List<UserModel> users = [];

  void getUsers() {
    if (users.isEmpty) {
      emit(GetAllUsersLoadingState());

      FirebaseFirestore.instance.collection('users').get().then((value) {
        for (var userData in value.docs) {
          if (userData['uid'] != user!.uid) {
            users.add(UserModel.fromJson(userData.data()));
          }
        }
        emit(GetAllUsersSuccessState());
      }).catchError((error) {
        emit(GetAllUsersErrorState());
      });
    }
  }

  String messageText = '';
  final messageController = TextEditingController();

  void changeMessage(String value) {
    messageText = value;
    emit(ChangeMessageState());
  }

  void sendMessage({
    required String receiverId,
    required Timestamp dateTime,
  }) {
    MessageModel message = MessageModel(
      user!.uid,
      receiverId,
      dateTime,
      messageController.text.trim(),
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(message.toMap())
        .then((value) {
      messageText = '';
      messageController.clear();
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(user!.uid)
        .collection('messages')
        .add(message.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];

  void getMessages(String receiverId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      for (var messageData in event.docs) {
        messages.add(MessageModel.fromJson(messageData.data()));
      }
      emit(GetMessagesSuccessState());
    });
  }
}
