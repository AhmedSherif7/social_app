import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class LikesBottomSheet extends StatelessWidget {
  const LikesBottomSheet(this.post, {Key? key}) : super(key: key);

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Likes'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(IconBroken.Arrow___Left_2),
        ),
      ),
      body: ListView.separated(
        itemCount: post.likes!.length,
        itemBuilder: (context, index) {
          return FutureBuilder<DocumentSnapshot>(
            future:
                SocialCubit.get(context).getUserDataById(post.likes![index]),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              return ConditionalBuilder(
                condition: snapshot.connectionState == ConnectionState.done,
                builder: (context) {
                  final UserModel user = UserModel.fromJson(
                      snapshot.data!.data() as Map<String, dynamic>);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20.0,
                          backgroundImage: NetworkImage(user.image!),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          user.name!,
                          style: const TextStyle(
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        const Icon(
                          Icons.check_circle,
                          color: Colors.blue,
                          size: 16.0,
                        ),
                      ],
                    ),
                  );
                },
                fallback: (context) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SkeletonItem(
                          child: ListTile(
                            leading: const SkeletonAvatar(
                              style: SkeletonAvatarStyle(
                                shape: BoxShape.circle,
                                width: 50,
                                height: 50,
                              ),
                            ),
                            title: SkeletonParagraph(
                              style: SkeletonParagraphStyle(
                                lines: 1,
                                lineStyle: SkeletonLineStyle(
                                  randomLength: true,
                                  height: 10,
                                  borderRadius: BorderRadius.circular(8),
                                  minLength:
                                      MediaQuery.of(context).size.width / 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              );
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.grey[300],
          );
        },
      ),
    );
  }
}
