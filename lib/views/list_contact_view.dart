import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../contacts_cubit/list/cubit/contact_list_cubit.dart';
import '../contacts_cubit/list/cubit/contact_list_cubit_state.dart';
import '../widgets/contact_item.dart';
import '../widgets/edit_dialog.dart';
import 'add_contact_view.dart';

class ListContactView extends StatefulWidget {
  const ListContactView({super.key});

  @override
  State<ListContactView> createState() => _ListContactViewState();
}

class _ListContactViewState extends State<ListContactView> {
  @override
  void initState() {
    super.initState();
    context.read<ContactListCubit>().fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ContactListCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de contatos'),
      ),
      body: BlocBuilder<ContactListCubit, ContactListCubitState>(
        builder: (context, state) {
          if (state is ContactListCubitLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ContactListCubitLoaded) {
            final contacts = state.contacts;
            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (BuildContext context, int index) {
                var contact = contacts[index];
                return Dismissible(
                  onDismissed: (DismissDirection dismissDirection) async {
                    await cubit.deleteContact(contact.objectId!);
                  },
                  key: Key(contact.objectId!),
                  child: ContactItem(
                    contact: contact,
                    onEditPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditContactDialog(
                          contact: contact,
                        ),
                      );
                      cubit.fetchContacts();
                    },
                  ),
                );
              },
            );
          } else if (state is ContactListCubitError) {
            return Center(child: Text(state.errorMessage));
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const AddContactView(),
          ));
          cubit.fetchContacts();
        },
      ),
    );
  }
}
