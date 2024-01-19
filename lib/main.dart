import 'package:contatosbloc/contacts_cubit/list/cubit/contact_list_cubit.dart';
import 'package:contatosbloc/views/add_contact_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'views/list_contact_view.dart';
import 'repositories/contact_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactListCubit(ContactRepository()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Contatos',
        initialRoute: '/',
        routes: {
          '/': (context) => const ListContactView(),
          '/adiciona': (context) => const AddContactView(),
        },
      ),
    );
  }
}
