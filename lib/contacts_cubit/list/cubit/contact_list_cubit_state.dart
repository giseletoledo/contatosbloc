import '../../../model/contact.dart';

abstract class ContactListCubitState {}

class ContactListCubitLoading extends ContactListCubitState {}

class ContactListCubitInitial extends ContactListCubitState {
  ContactListCubitInitial();
}

class ContactListCubitLoaded extends ContactListCubitState {
  final List<Contact> contacts;

  ContactListCubitLoaded(this.contacts);
}

class ContactListCubitError extends ContactListCubitState {
  final String errorMessage;

  ContactListCubitError(this.errorMessage);
}
