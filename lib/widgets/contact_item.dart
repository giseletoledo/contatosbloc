import 'package:contatosapp/model/contact.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContactItem extends StatelessWidget {
  final Contact contact;
  final VoidCallback onEditPressed;

  const ContactItem(
      {super.key, required this.contact, required this.onEditPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(contact.urlavatar ?? 'sem imagem'),
      ),
      title: Text(contact.name ?? "sem nome"),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Telefone: ${contact.phone}"),
          Text("Email: ${contact.email}"),
          Text(
              "Data de criação: ${contact.createdAt != null ? DateFormat('dd/MM/yyyy').format(contact.createdAt!) : 'Sem data'}")
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              onEditPressed();
            },
          ),
        ],
      ),
    );
  }
}
