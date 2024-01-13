import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../model/contact.dart';
import '../../../repositories/contact_repository.dart';

part 'contact_list_cubit_state.dart';

part 'contact_list_cubit.freezed.dart';

class ContactListCubit extends Cubit<ContactListCubitState> {
  ContactListCubit(this._contactRepository)
      : super(const ContactListCubitState.initial());

  final ContactRepository _contactRepository;

  Future<void> fetchContacts() async {
    emit(const ContactListCubitState.loading());
    try {
      final contacts = await _contactRepository.getContacts();
      emit(ContactListCubitState.loaded(contacts));
    } catch (e) {
      emit(ContactListCubitState.error(e.toString()));
    }
  }

  Future<void> addContact(Contact contact) async {
    try {
      await _contactRepository.createContact(contact);
      final contacts = await _contactRepository.getContacts(); // Refresh list
      emit(ContactListCubitState.loaded(contacts));
    } catch (e) {
      emit(ContactListCubitState.error(e.toString()));
    }
  }

  Future<void> updateContact(Contact contact) async {
    try {
      await _contactRepository.updateContact(contact);
      final contacts = await _contactRepository.getContacts(); // Refresh list
      emit(ContactListCubitState.loaded(contacts));
    } catch (e) {
      emit(ContactListCubitState.error(e.toString()));
    }
  }

  Future<void> deleteContact(String objectId) async {
    try {
      await _contactRepository.deleteContact(objectId);
      final contacts = await _contactRepository.getContacts(); // Refresh list
      emit(ContactListCubitState.loaded(contacts));
    } catch (e) {
      emit(ContactListCubitState.error(e.toString()));
    }
  }
}
