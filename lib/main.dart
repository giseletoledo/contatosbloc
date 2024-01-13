import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'contacts_cubit/list/cubit/contact_list_cubit.dart';
import 'pages/contact_list.dart';
import 'repositories/contact_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final contactRepository = ContactRepository();
  final contactListCubit = ContactListCubit(contactRepository);

  runApp(
    BlocProvider<ContactListCubit>(
      create: (context) => contactListCubit,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ContactList(),
      ),
    ),
  );
}
