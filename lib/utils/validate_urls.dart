// utils.dart

import 'dart:convert';
import 'dart:typed_data';

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
