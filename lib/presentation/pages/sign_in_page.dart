import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdb_movie_app/presentation/bloc/sign_in_bloc.dart';
import 'package:omdb_movie_app/presentation/bloc/sign_in_event.dart';
import 'package:omdb_movie_app/presentation/bloc/sign_in_state.dart';
import 'package:omdb_movie_app/presentation/pages/search_page.dart';

/// Page for user sign in.
class SignInPage extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign in'),
        ),
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.5,
            child: BlocConsumer<SignInBloc, SignInState>(
                listener: (context, state) {
              if (state is SignInLoaded) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => SearchPage(),
                  ),
                  (Route<dynamic> route) => false,
                );
              }
            }, builder: (context, state) {
              if (state is SignInLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Form(
                key: formKey,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.person),
                          ),
                          onSubmitted: (query) {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.password),
                          ),
                          onSubmitted: (query) {},
                        ),
                      ),
                      if (state is SignInError)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(state.message),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 24.0,
                          horizontal: 8.0,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: const ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll<Color>(Colors.grey),
                            ),
                            onPressed: () {
                              context.read<SignInBloc>().add(
                                    UserSignInEvent(
                                      _usernameController.text,
                                      _passwordController.text,
                                    ),
                                  );
                            },
                            child: const Text('LOGIN'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ));
  }
}
