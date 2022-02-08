import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/network/local/cache_helper.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/helper_functions.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        var cubit = SocialCubit.get(context)..getUserData();

        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {
            if (state is NewPostState) {
              navigateTo(context, const NewPostScreen());
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text(cubit.titles[cubit.currentIndex]),
                actions: [
                  TextButton(
                    onPressed: () async {
                      Constants.uid = null;
                      SocialCubit.get(context).user = null;
                      SocialCubit.get(context).currentIndex = 0;
                      await FirebaseAuth.instance.signOut().then((value) {
                        CacheHelper.removeData(key: 'uid').then((value) {
                          navigateReplacement(context, const LoginScreen());
                        });
                      });
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
              body: cubit.screen[cubit.currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: cubit.currentIndex,
                onTap: (int index) {
                  cubit.changeCurrentIndex(index);
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(IconBroken.Home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(IconBroken.Chat),
                    label: 'Chats',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(IconBroken.Paper_Upload),
                    label: 'Post',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(IconBroken.Profile),
                    label: 'Profile',
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
