import 'package:contatosbloc/contacts_cubit/list/cubit/contact_list_cubit.dart';
import 'package:contatosbloc/pages/add_contact_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'pages/list_contact_page.dart';
import 'repositories/contact_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactListCubit(ContactRepository()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Contatos',
        initialRoute: '/',
        routes: {
          '/': (context) => const ListContactPage(),
          '/adiciona': (context) => const AddContactPage(),
        },
      ),
    );
  }
}
