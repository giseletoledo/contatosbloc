import 'package:contatosbloc/repositories/contact_repository.dart';

import '../../../model/contact.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_list_cubit_state.dart';
part 'contact_list_cubit.freezed.dart';

class ContactListCubit extends Cubit<ContactListCubitState> {
  final ContactRepository _repository;

  ContactListCubit({required ContactRepository repository})
      : _repository = repository,
        super(ContactListCubitState.initial());

  Future<void> findAll() async {
    emit(ContactListCubitState.loading());
    final contacts = await _repository.getContacts();
    await Future.delayed(const Duration(seconds: 1));
    emit(ContactListCubitState.data(contacts: contacts));
  }
}
