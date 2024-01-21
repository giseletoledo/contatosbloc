import 'package:bloc_test/bloc_test.dart';
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
  });
}
