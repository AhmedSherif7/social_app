import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';
import 'package:social_app/models/comments_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/cubit/cubit.dart';

import '../../shared/helper_functions.dart';

class CommentItem extends StatefulWidget {
  const CommentItem(this.comment, {Key? key}) : super(key: key);

  final CommentModel comment;

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  late final Future<DocumentSnapshot<Object?>> userFuture;

  @override
  void initState() {
    userFuture = SocialCubit.get(context).getUserDataById(widget.comment.uid!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: userFuture,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          UserModel user =
              UserModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);
          return ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(user.image!),
            ),
            title: Row(
              children: [
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
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    widget.comment.text!,
                  ),
                ),
                Text(
                  formatDate(widget.comment.dateTime!),
                  style: Theme.of(context).textTheme.caption!.copyWith(
                        height: 1.4,
                      ),
                )
              ],
            ),
          );
        }

        return SkeletonItem(
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
                  minLength: MediaQuery.of(context).size.width / 2,
                ),
              ),
            ),
            subtitle: Column(
              children: [
                SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 10,
                  ),
                ),
                SkeletonParagraph(
                  style: SkeletonParagraphStyle(
                    lines: 1,
                    lineStyle: SkeletonLineStyle(
                      randomLength: true,
                      height: 10,
                      borderRadius: BorderRadius.circular(8),
                      minLength: MediaQuery.of(context).size.width / 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
