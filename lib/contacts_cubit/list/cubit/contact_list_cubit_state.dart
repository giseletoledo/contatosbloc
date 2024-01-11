part of 'contact_list_cubit.dart';

@freezed
class ContactListCubitState with _$ContactListCubitState {
  factory ContactListCubitState.initial() = _Initial;
  factory ContactListCubitState.loading() = _loading;
  factory ContactListCubitState.data({required List<Contact> contacts}) = _Data;
  factory ContactListCubitState.error({required String error}) = _Error;
}
