import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class ChatDetailsScreen extends StatelessWidget {
  const ChatDetailsScreen(this.user, {Key? key}) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getMessages(user.uid!);

        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: ListTile(
                  leading: CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(user.image!),
                  ),
                  title: Text(
                    user.name!,
                    style: const TextStyle(
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              body: ConditionalBuilder(
                condition: SocialCubit.get(context).messages.isNotEmpty,
                builder: (context) {
                  return BodyBuilder(
                    ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        var message = SocialCubit.get(context).messages[index];
                        if (SocialCubit.get(context).user!.uid ==
                            message.senderId) {
                          return MyMessageBuilder(message);
                        }
                        return MessageBuilder(message);
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 15.0,
                        );
                      },
                      itemCount: SocialCubit.get(context).messages.length,
                    ),
                    user,
                  );
                },
                fallback: (context) {
                  return SocialCubit.get(context).messages.isEmpty &&
                          state is GetMessagesSuccessState
                      ? BodyBuilder(
                          const Center(
                            child: Text('No Messages Yet'),
                          ),
                          user,
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class BodyBuilder extends StatelessWidget {
  const BodyBuilder(this.child, this.user, {Key? key}) : super(key: key);

  final Widget child;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 20.0, left: 20.0, right: 20.0, bottom: 15.0),
      child: Column(
        children: [
          Expanded(
            child: child,
          ),
          Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            padding: const EdgeInsets.only(left: 8.0),
            margin: const EdgeInsets.only(top: 5.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onChanged: (String value) =>
                        SocialCubit.get(context).changeMessage(value),
                    controller: SocialCubit.get(context).messageController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'type your message here ...',
                    ),
                  ),
                ),
                Container(
                  height: 50.0,
                  color: Theme.of(context).primaryColor,
                  child: MaterialButton(
                    minWidth: 1.0,
                    onPressed: SocialCubit.get(context)
                            .messageController
                            .text
                            .trim()
                            .isEmpty
                        ? null
                        : () {
                            SocialCubit.get(context).sendMessage(
                              receiverId: user.uid!,
                              dateTime: Timestamp.now(),
                            );
                          },
                    child: const Icon(
                      IconBroken.Send,
                      size: 16.0,
                      color: Colors.white,
                    ),
                    disabledColor: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyMessageBuilder extends StatelessWidget {
  const MyMessageBuilder(this.message, {Key? key}) : super(key: key);

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 14.0,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          borderRadius: const BorderRadiusDirectional.only(
            bottomStart: Radius.circular(10.0),
            topEnd: Radius.circular(10.0),
            topStart: Radius.circular(10.0),
          ),
        ),
        child: Text(message.text!),
      ),
    );
  }
}

class MessageBuilder extends StatelessWidget {
  const MessageBuilder(this.message, {Key? key}) : super(key: key);

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 14.0,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: const BorderRadiusDirectional.only(
            bottomEnd: Radius.circular(10.0),
            topEnd: Radius.circular(10.0),
            topStart: Radius.circular(10.0),
          ),
        ),
        child: Text(message.text!),
      ),
    );
  }
}
