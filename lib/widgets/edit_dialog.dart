import 'package:cached_network_image/cached_network_image.dart';
import 'package:contatosbloc/model/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../contacts_cubit/list/cubit/contact_list_cubit.dart';
import '../utils/validateUrls.dart';

class EditContactDialog extends StatelessWidget {
  final Contact contact;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController urlAvatarController;

  const EditContactDialog({
    super.key,
    required this.contact,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.urlAvatarController,
  });

  @override
  Widget build(BuildContext context) {
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
            decoration:
                const InputDecoration(labelText: 'URL da Imagem de Perfil'),
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

            // Update the contact using the cubit
            final contactCubit = BlocProvider.of<ContactListCubit>(context);
            await contactCubit.updateContact(contact);

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  // ... (rest of your code for validateUrl and isValidUrl functions)
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
