import 'package:cached_network_image/cached_network_image.dart';
import 'package:contatosbloc/model/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../contacts_cubit/list/cubit/contact_list_cubit.dart';
import '../utils/validate_urls.dart';

class EditContactDialog extends StatefulWidget {
  final Contact contact;

  const EditContactDialog({
    super.key,
    required this.contact,
  });

  @override
  State<EditContactDialog> createState() => _EditContactDialogState();
}

class _EditContactDialogState extends State<EditContactDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _urlAvatarController = TextEditingController();
  final ValueNotifier<String> _urlAvatarNotifier = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();

    // Inicialize os controladores com os dados do contato
    _nameController.text = widget.contact.name ?? '';
    _phoneController.text = widget.contact.phone ?? '';
    _emailController.text = widget.contact.email ?? '';
    _urlAvatarController.text = widget.contact.urlavatar ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _urlAvatarController.dispose();
    _urlAvatarNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Editar Contato"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              _showImagePreview(_urlAvatarController.text, context);
            },
            child: CircleAvatar(
              radius: 50,
              backgroundImage: _urlAvatarController.text.isNotEmpty &&
                      isValidUrl(_urlAvatarController.text)
                  ? CachedNetworkImageProvider(_urlAvatarController.text)
                  : null,
              child: _urlAvatarController.text.isNotEmpty
                  ? null
                  : const Icon(
                      Icons.camera,
                      size: 40,
                      color: Colors.white,
                    ),
            ),
          ),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: 'Phone'),
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextFormField(
            controller: _urlAvatarController,
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
            final contactCubit = BlocProvider.of<ContactListCubit>(context);

            //Atualiza os dados do contato com os valores do formulário
            widget.contact.name = _nameController.text;
            widget.contact.phone = _phoneController.text;
            widget.contact.email = _emailController.text;
            widget.contact.urlavatar = _urlAvatarController.text;

            //Atualização no estado
            await contactCubit.updateContact(widget.contact);

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
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
