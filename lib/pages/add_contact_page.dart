import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../model/contact.dart';
import '../repositories/contact_repository.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _urlAvatarController = TextEditingController();
  final ValueNotifier<String> _urlAvatarNotifier = ValueNotifier<String>('');

  String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório.';
    }
    if (!value.startsWith('http://') && !value.startsWith('https://')) {
      // A URL começa com "http://" ou "https://", considerando válida.
      return 'A URL deve começar com "http://" ou "https://".';
    } else if (value.startsWith('data:image')) {
      // A URL parece ser uma imagem codificada em base64, considerando inválida.
      return 'Esta URL parece ser uma imagem codificada em base64.';
    }
    return null;
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

  var carregando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Contato'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  _showImagePreview();
                },
                child: ValueListenableBuilder<String>(
                  valueListenable: _urlAvatarNotifier,
                  builder: (context, valueNotifierAttributeValue, child) {
                    return CircleAvatar(
                      radius: 50,
                      backgroundImage: _urlAvatarController.text.isNotEmpty
                          ? CachedNetworkImageProvider(
                              _urlAvatarController.text)
                          : null,
                      child: _urlAvatarController.text.isNotEmpty
                          ? null
                          : const Icon(
                              Icons.camera,
                              size: 40,
                              color: Colors.white,
                            ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor preencha o nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor preencha um número de telefone';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  } else if (!isValidEmail(value)) {
                    return 'Por favor preencha um email válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _urlAvatarController,
                decoration:
                    const InputDecoration(labelText: 'URL da Imagem de Perfil'),
                validator: validateUrl,
                onChanged: (value) {
                  if (!isValidUrl(value)) {
                    // Exiba uma mensagem de erro e não permita que o valor inválido seja definido
                    // como o valor do campo.
                    _urlAvatarController.value = const TextEditingValue(
                      text: '',
                      selection: TextSelection.collapsed(offset: 0),
                    );
                  } else {
                    _urlAvatarNotifier.value = value;
                  }
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  await _addContact();
                },
                child: const Text('Adicionar Contato'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImagePreview() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pré-Visualização da Imagem'),
          content: _urlAvatarController.text.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: _urlAvatarNotifier.value,
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

  Future<void> _addContact() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final email = _emailController.text;
      final phone = _phoneController.text;
      final urlAvatar = _urlAvatarController.text;

      final newContact = Contact.criar(
          name: name,
          phone: phone,
          email: email,
          urlavatar: urlAvatar,
          idcontact: const Uuid().v4());

      // Chame o método para criar o contato no repositório
      await ContactRepository().createContact(newContact);

      // Limpe os campos após adicionar o contato
      _nameController.clear();
      _phoneController.clear();
      _emailController.clear();
      _urlAvatarController.clear();

      setState(() {
        // Limpe a imagem da URL
        _urlAvatarController.clear();
      });
    } else {
      // Campos em branco, mostrar um alerta
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Campos em Branco'),
            content: const Text('Por favor, preencha todos os campos.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(email);
  }
}
