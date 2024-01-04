import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

import '../repositories/contact_repository.dart';
import '../widgets/contact_item.dart';
import 'add_contact_page.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
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

  ContactRepository contactRepository = ContactRepository();
  var _contactList = [];
  var carregando = false;

  @override
  void initState() {
    super.initState();
    getContacts();
  }

  void getContacts() async {
    setState(() {
      carregando = true;
    });
    _contactList = await contactRepository.getContacts();
    setState(() {
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lista de contatos'),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AddContactPage(),
              ));
              getContacts();
            }),
        body: Container(
          child: Column(
            children: [
              carregando
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: ListView.builder(
                          itemCount: _contactList.length,
                          itemBuilder: (BuildContext context, int index) {
                            var contact = _contactList[index];
                            return Dismissible(
                                onDismissed:
                                    (DismissDirection dismissDirection) async {
                                  await contactRepository
                                      .deleteContact(contact.objectId);
                                  getContacts();
                                },
                                key: Key(contact.objectId),
                                child: ContactItem(
                                  contact: contact,
                                  onEditPressed: () async {
                                    await showEditDialog(context, contact);
                                    getContacts();
                                  },
                                ));
                          }),
                    ),
            ],
          ),
        ));
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
                    await ContactRepository().updateContact(contact);

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
