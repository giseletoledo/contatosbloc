part of 'contact_list_cubit.dart';

@freezed
class ContactListCubitState with _$ContactListCubitState {
  const factory ContactListCubitState.initial() = _Initial;
  const factory ContactListCubitState.loading() = _Loading;
  const factory ContactListCubitState.loaded(List<Contact> contacts) = _Loaded;
  const factory ContactListCubitState.error(String error) = _Error;
}
