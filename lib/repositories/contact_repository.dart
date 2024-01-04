import '../back4app/back4app_custom_dio.dart';
import '../model/contact.dart';

class ContactRepository {
  final _customDio = Back4AppCustomDio();
  final String url = '/contact';

  ContactRepository();

  Future<List<Contact>> getContacts() async {
    final result = await _customDio.dio.get(url);
    final data = result.data['results'] as List;
    final contacts = data.map((item) => Contact.fromMap(item)).toList();
    return contacts;
  }

  Future<void> createContact(Contact contact) async {
    try {
      await _customDio.dio.post(
        url,
        data: contact.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateContact(Contact contact) async {
    try {
      await _customDio.dio.put(
        "$url/${contact.objectId}",
        data: contact.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteContact(String objectId) async {
    try {
      await _customDio.dio.delete(
        "$url/$objectId",
      );
    } catch (e) {
      rethrow;
    }
  }
}
