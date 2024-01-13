import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../contacts_cubit/list/cubit/contact_list_cubit.dart';
import '../contacts_cubit/list/cubit/contact_list_cubit_state.dart';
import '../widgets/contact_item.dart';
import 'add_contact_page.dart';

class ListContactPage extends StatefulWidget {
  const ListContactPage({super.key});

  @override
  State<ListContactPage> createState() => _ListContactPageState();
}

class _ListContactPageState extends State<ListContactPage> {
  String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório.';
    }
    if (value.startsWith('http://') || value.startsWith('https://')) {
      // A URL começa com "http://" ou "https://", considerando válida.
      return null;
    } else if (value.startsWith('data:image')) {
      // A URL parece ser uma imagem codificada em base64, considerando inválida.
      return 'Esta URL parece ser uma imagem codificada em base64.';
    } else {
      return 'A URL deve começar com "http://" ou "https://".';
    }
  }

  bool isValidUrl(String url, {Uint8List? imageBytes}) {
    if (url.isEmpty ||
        (!url.startsWith('http://') && !url.startsWith('https://'))) {
      return false; // A URL não começa com "http://" ou "https://", então é inválida.
    }

    final regex = RegExp('^data:image');
    if (regex.hasMatch(url)) {
      try {
        imageBytes = Uint8List.fromList(base64.decode(url.split(",").last));
      } catch (e) {
        // Lida com erros na conversão da URL `data:`
        imageBytes = null;
        return false;
      }
    }

    return true;
  }

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
                      showEditDialog(context, contact);
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
            builder: (context) => const AddContactPage(),
          ));
          cubit.fetchContacts();
        },
      ),
    );
  }

  Future<void> showEditDialog(BuildContext context, contact) async {
    TextEditingController nameController =
        TextEditingController(text: contact.name);
    TextEditingController phoneController =
        TextEditingController(text: contact.phone);
    TextEditingController emailController =
        TextEditingController(text: contact.email);
    TextEditingController urlAvatarController =
        TextEditingController(text: contact.urlavatar);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Editar Contato"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      _showImagePreview(urlAvatarController.text, context);
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: urlAvatarController.text.isNotEmpty &&
                              isValidUrl(urlAvatarController.text)
                          ? CachedNetworkImageProvider(urlAvatarController.text)
                          : null,
                      child: urlAvatarController.text.isNotEmpty
                          ? null
                          : const Icon(
                              Icons.camera,
                              size: 40,
                              color: Colors.white,
                            ),
                    ),
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Phone'),
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextFormField(
                    controller: urlAvatarController,
                    decoration: const InputDecoration(
                        labelText: 'URL da Imagem de Perfil'),
                    validator: validateUrl,
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text("Save"),
                  onPressed: () async {
                    // Update the contact with the edited data
                    contact.name = nameController.text;
                    contact.phone = phoneController.text;
                    contact.email = emailController.text;
                    contact.urlavatar = urlAvatarController.text;

                    // Limpe a imagem da URL
                    //await ContactRepository().updateContact(contact);

                    final contactCubit = BlocProvider.of<ContactListCubit>(
                        context); // Access the cubit from context

                    await contactCubit.updateContact(contact);

                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showImagePreview(String url, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pré-Visualização da Imagem'),
          content: url.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: url,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
              : const Text('Nenhuma URL fornecida'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}
