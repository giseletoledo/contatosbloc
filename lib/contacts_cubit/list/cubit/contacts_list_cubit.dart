import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../model/contact.dart';

part 'contacts_list_cubit_state.dart';

@freezed
class ContactListCubitState with _$ContactListCubitState {
  const factory ContactListCubitState.initial() = _Initial;
  const factory ContactListCubitState.loading() = _Loading;
  const factory ContactListCubitState.data({required List<Contact> contacts}) =
      _Data;
  const factory ContactListCubitState.error({required String error}) = _Error;
}
