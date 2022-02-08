import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

import '../../shared/helper_functions.dart';
import '../comments/comments_screen.dart';
import '../likes/likes_bottom_sheet.dart';

class PostItem extends StatefulWidget {
  const PostItem(this.post, {Key? key}) : super(key: key);

  final PostModel post;

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  late final Future<DocumentSnapshot> userFuture;

  @override
  void initState() {
    userFuture = SocialCubit.get(context).getUserDataById(widget.post.uid!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isPostLiked = SocialCubit.get(context).isPostLiked(widget.post.likes!);

    return FutureBuilder<DocumentSnapshot>(
      future: userFuture,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final UserModel user =
              UserModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);

          return Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 5.0,
            margin: const EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25.0,
                        backgroundImage: NetworkImage(user.image!),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
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
                            Text(
                              formatDate(widget.post.dateTime!),
                              style:
                                  Theme.of(context).textTheme.caption!.copyWith(
                                        height: 1.4,
                                      ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.more_horiz,
                          size: 16.0,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                    ),
                    child: Divider(
                      color: Colors.grey[300],
                    ),
                  ),
                  Text(
                    widget.post.text!,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5.0,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.only(
                              end: 6.0,
                            ),
                            child: SizedBox(
                              height: 25.0,
                              child: MaterialButton(
                                onPressed: () {},
                                minWidth: 1.0,
                                padding: EdgeInsets.zero,
                                child: Text(
                                  '#software',
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(
                                        color: Colors.blue,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(
                              end: 6.0,
                            ),
                            child: SizedBox(
                              height: 25.0,
                              child: MaterialButton(
                                onPressed: () {},
                                minWidth: 1.0,
                                padding: EdgeInsets.zero,
                                child: Text(
                                  '#flutter',
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(
                                        color: Colors.blue,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (widget.post.postImage != '')
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        top: 15.0,
                      ),
                      child: Container(
                        height: 140.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            4.0,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(widget.post.postImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    IconBroken.Heart,
                                    size: 16.0,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    '${widget.post.likes!.length} likes',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return LikesBottomSheet(widget.post);
                                },
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(
                                    IconBroken.Chat,
                                    size: 16.0,
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    '${widget.post.commentsCount} comments',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              navigateTo(context, CommentsScreen(widget.post));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10.0,
                    ),
                    child: Divider(
                      color: Colors.grey[300],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18.0,
                                backgroundImage: NetworkImage(
                                    SocialCubit.get(context).user!.image!),
                              ),
                              const SizedBox(
                                width: 15.0,
                              ),
                              Text(
                                'write a comment ...',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(),
                              ),
                            ],
                          ),
                          onTap: () {
                            navigateTo(context, CommentsScreen(widget.post));
                          },
                        ),
                      ),
                      InkWell(
                        child: Row(
                          children: [
                            LikeButton(
                                size: 20,
                                circleColor: const CircleColor(
                                  start: Color(0xff00ddff),
                                  end: Color(0xff0099cc),
                                ),
                                bubblesColor: const BubblesColor(
                                  dotPrimaryColor: Color(0xff33b5e5),
                                  dotSecondaryColor: Color(0xff0099cc),
                                ),
                                isLiked: isPostLiked,
                                likeBuilder: (bool isLiked) {
                                  return Icon(
                                    isPostLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border_outlined,
                                    color:
                                        isPostLiked ? Colors.red : Colors.grey,
                                    size: 18,
                                  );
                                },
                                onTap: (bool value) async {
                                  SocialCubit.get(context).changeLikeState(
                                    like: isPostLiked,
                                    postId: widget.post.postId!,
                                  );
                                }),
                            Text(
                              SocialCubit.get(context)
                                      .isPostLiked(widget.post.likes!)
                                  ? 'Unlike'
                                  : 'Like',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                        onTap: () {
                          // SocialCubit.get(context).likePost(post['postId']!);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
