import 'package:bloc/bloc.dart';

import '../../../model/contact.dart';
import '../../../repositories/contact_repository.dart';
import 'contact_list_cubit_state.dart';

class ContactListCubit extends Cubit<ContactListCubitState> {
  ContactListCubit(this._contactRepository) : super(ContactListCubitInitial());

  final ContactRepository _contactRepository;

  Future<void> fetchContacts() async {
    _emitLoadingState();
    try {
      final contacts = await _contactRepository.getContacts();
      _emitLoadedState(contacts);
    } catch (e) {
      _emitErrorState(e.toString());
    }
  }

  Future<void> addContact(Contact contact) async {
    try {
      await _contactRepository.createContact(contact);
      _refreshContactList();
    } catch (e) {
      _emitErrorState(e.toString());
    }
  }

  Future<void> updateContact(Contact contact) async {
    try {
      await _contactRepository.updateContact(contact);
      _refreshContactList();
    } catch (e) {
      _emitErrorState(e.toString());
    }
  }

  Future<void> deleteContact(String objectId) async {
    try {
      await _contactRepository.deleteContact(objectId);
      _refreshContactList();
    } catch (e) {
      _emitErrorState(e.toString());
    }
  }

  // Funções privadas para emitir estados específicos

  void _emitLoadingState() {
    emit(ContactListCubitLoading());
  }

  void _emitLoadedState(List<Contact> contacts) {
    emit(ContactListCubitLoaded(contacts));
  }

  void _emitErrorState(String errorMessage) {
    //print('Erro ao adicionar contato: $errorMessage');
    emit(ContactListCubitError(errorMessage));
  }

  Future<void> _refreshContactList() async {
    _emitLoadingState();
    try {
      final contacts = await _contactRepository.getContacts();
      _emitLoadedState(contacts);
    } catch (e) {
      _emitErrorState(e.toString());
    }
  }
}
