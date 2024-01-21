import 'package:bloc_test/bloc_test.dart';
import 'package:contatosbloc/model/contact.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:contatosbloc/contacts_cubit/list/cubit/contact_list_cubit.dart';
import 'package:contatosbloc/contacts_cubit/list/cubit/contact_list_cubit_state.dart';
import 'package:contatosbloc/repositories/contact_repository.dart';

class MockContactRepository extends Mock implements ContactRepository {}

void main() {
  group('ContactListCubit', () {
    late ContactListCubit cubit;
    late MockContactRepository mockContactRepository;

    setUp(() {
      mockContactRepository = MockContactRepository();
      cubit = ContactListCubit(mockContactRepository);
    });

    tearDown(() {
      cubit.close();
    });

    // Alteração: registro do fallback value para `Contact`
    setUpAll(() {
      registerFallbackValue(Contact(
        name: '',
        phone: '',
        email: '',
        urlavatar: '',
      ));
    });

    blocTest<ContactListCubit, ContactListCubitState>(
      'Deve emitir o estado Loading e depois Loaded',
      build: () => cubit,
      act: (cubit) async {
        // Configura o mock para retornar uma lista vazia.
        when(() => mockContactRepository.getContacts())
            .thenAnswer((_) async => []);
        await cubit.fetchContacts();
      },
      expect: () => [
        isA<ContactListCubitLoading>(),
        isA<ContactListCubitLoaded>(),
      ],
    );

    blocTest<ContactListCubit, ContactListCubitState>(
      'Deve emitir o estado Loading e depois Error em caso de falha na busca',
      build: () => cubit,
      act: (cubit) async {
        // Configura o mock para lançar um erro.
        when(() => mockContactRepository.getContacts())
            .thenThrow(Exception('Erro de teste'));
        await cubit.fetchContacts();
      },
      expect: () => [
        isA<ContactListCubitLoading>(),
        isA<ContactListCubitError>(),
      ],
    );

    blocTest<ContactListCubit, ContactListCubitState>(
      'Deve emitir Loading e depois Loaded ao adicionar um contato válido',
      build: () => cubit,
      act: (cubit) async {
        // Configura o mock para aceitar qualquer entrada.
        when(() => mockContactRepository.createContact(any()))
            .thenAnswer((_) async {
          final contact = Contact(
            objectId: "0FQaOMiQQr",
            name: 'Nome',
            phone: '123456789',
            email: 'email@example.com',
            urlavatar:
                'https://cdn4.iconfinder.com/icons/diversity-v2-0-volume-03/64/superhero-catwoman-african-black-costume-1024.png',
            idcontact: "35a6969e-12aa-4bdb-989c-a7d4f482dcc7",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          // Adiciona o contato, que deveria emitir estados.
          await cubit.addContact(contact);
        });

        // Não é necessário verificar o estado inicial, pois isso não emitiria estados.
      },
      expect: () => [
        isA<ContactListCubitLoading>(),
        expectLater(cubit.state, isA<ContactListCubitLoaded>()),
      ],
    );
    ;

    blocTest<ContactListCubit, ContactListCubitState>(
      'Deve emitir Loading e depois Loaded ao adicionar um contato válido',
      build: () => cubit,
      act: (cubit) async {
        // Configura o mock para aceitar qualquer entrada.
        when(() => mockContactRepository.createContact(any()))
            .thenAnswer((_) async {
          final contact = Contact(
            objectId: "0FQaOMiQQr",
            name: 'Nome',
            phone: '123456789',
            email: 'email@example.com',
            urlavatar:
                'https://cdn4.iconfinder.com/icons/diversity-v2-0-volume-03/64/superhero-catwoman-african-black-costume-1024.png',
            idcontact: "35a6969e-12aa-4bdb-989c-a7d4f482dcc7",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          // Adiciona o contato, que deveria emitir estados.
          await cubit.addContact(contact);
        });

        // Não é necessário verificar o estado inicial, pois isso não emitiria estados.
      },
      expect: () => [
        isA<ContactListCubitLoading>(),
        isA<ContactListCubitLoaded>(),
      ],
    );
  });
}
