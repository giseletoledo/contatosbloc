part of 'contacts_list_cubit.dart';

@freezed
abstract class ContactsListCubitState with _$ContactsListCubitState {
  factory ContactsListCubitState.initial() = _ContactsListCubitState;
  factory ContactsListCubitState.data({required List<Contact> contacts}) =
      _ContactListStateData;
}
