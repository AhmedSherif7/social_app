import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletons/skeletons.dart';
import 'package:social_app/models/comments_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

import 'comment_item.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen(this.post, {Key? key}) : super(key: key);

  final PostModel post;

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final commentController = TextEditingController();
  String comment = '';
  late final Stream<QuerySnapshot> commentsStream;

  @override
  void initState() {
    commentsStream = SocialCubit.get(context).getComments(widget.post.postId!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Comments'),
          ),
          body: Container(
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: commentsStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Something went wrong'),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ListView.separated(
                          itemCount: 10,
                          itemBuilder: (context, index) {
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
                                      minLength:
                                          MediaQuery.of(context).size.width / 2,
                                    ),
                                  ),
                                ),
                                subtitle: Column(
                                  children: [
                                    SkeletonAvatar(
                                      style: SkeletonAvatarStyle(
                                        width: double.infinity,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                10,
                                      ),
                                    ),
                                    SkeletonParagraph(
                                      style: SkeletonParagraphStyle(
                                        lines: 1,
                                        lineStyle: SkeletonLineStyle(
                                          randomLength: true,
                                          height: 10,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          minLength: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: Colors.grey[400],
                            );
                          },
                        );
                      }

                      return ListView.separated(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          CommentModel comment = CommentModel.fromJson(
                              snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>);
                          return CommentItem(comment);
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: Colors.grey[400],
                          );
                        },
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.only(left: 14.0),
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller:
                                    SocialCubit.get(context).commentController,
                                autofocus: false,
                                decoration: const InputDecoration(
                                  hintText: 'write a comment',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 0,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 0,
                                    ),
                                  ),
                                ),
                                onChanged: (value) => SocialCubit.get(context)
                                    .changeComment(value),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed:
                          SocialCubit.get(context).commentText.trim() == ''
                              ? null
                              : () {
                                  SocialCubit.get(context).createComment(
                                    postId: widget.post.postId!,
                                    timestamp: Timestamp.now(),
                                  );
                                },
                      icon: const Icon(Icons.send),
                      color: Theme.of(context).primaryColor,
                      disabledColor: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
