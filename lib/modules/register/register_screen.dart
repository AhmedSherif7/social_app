import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/shared/components/default_button.dart';
import 'package:social_app/shared/components/default_form_field.dart';
import 'package:social_app/shared/helper_functions.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final phoneController = TextEditingController();
    final emailFocusNode = FocusNode();
    final passwordFocusNode = FocusNode();
    final phoneFocusNode = FocusNode();

    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is CreateUserSuccessState) {
            navigateReplacement(context, const HomeLayout());
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REGISTER',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.black),
                        ),
                        Text(
                          'Register now to communicate with friends',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.grey,
                                    fontSize: 18.0,
                                  ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        DefaultFormFiled(
                          controller: nameController,
                          type: TextInputType.name,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'Please, enter your name';
                            }
                            return null;
                          },
                          label: 'Name',
                          prefix: Icons.person_outlined,
                          onSubmit: (_) {
                            FocusScope.of(context).requestFocus(emailFocusNode);
                          },
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        DefaultFormFiled(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          focusNode: emailFocusNode,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'Please, enter your email address';
                            } else if (!value.contains('@')) {
                              return 'Please, enter a valid email address';
                            }
                            return null;
                          },
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                          onSubmit: (_) {
                            FocusScope.of(context)
                                .requestFocus(passwordFocusNode);
                          },
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        DefaultFormFiled(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          isPassword: RegisterCubit.get(context).isPassword,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'Password is too short';
                            }
                            return null;
                          },
                          label: 'Password',
                          prefix: Icons.lock_outlined,
                          suffix: RegisterCubit.get(context).suffix,
                          suffixPressed: () {
                            RegisterCubit.get(context)
                                .changePasswordVisibility();
                          },
                          focusNode: passwordFocusNode,
                          onSubmit: (_) {
                            FocusScope.of(context).requestFocus(phoneFocusNode);
                          },
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        DefaultFormFiled(
                          controller: phoneController,
                          type: TextInputType.phone,
                          focusNode: phoneFocusNode,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'Please, enter your phone number';
                            }
                            return null;
                          },
                          label: 'Phone',
                          prefix: Icons.phone_outlined,
                          onSubmit: (_) {
                            if (formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();
                              RegisterCubit.get(context).userRegister(
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                phone: phoneController.text,
                              );
                            }
                          },
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! RegisterLoadingState,
                          builder: (context) => Column(
                            children: [
                              DefaultButton(
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    FocusScope.of(context).unfocus();
                                    RegisterCubit.get(context).userRegister(
                                      name: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      phone: phoneController.text,
                                    );
                                  }
                                },
                                text: 'register',
                                isUpperCase: true,
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Row(
                                children: [
                                  const Text('Already have an account?'),
                                  TextButton(
                                    onPressed: () {
                                      navigateReplacement(
                                        context,
                                        const LoginScreen(),
                                      );
                                    },
                                    child: const Text('LOGIN'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          fallback: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
