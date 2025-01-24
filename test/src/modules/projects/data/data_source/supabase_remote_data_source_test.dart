import 'package:action/src/modules/projects/data/data_source/supabase_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  late SupabaseProjectRemoteDataSource remoteDataSource;
  late SupabaseClient mockSupabase;
  late MockSupabaseHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockSupabaseHttpClient();

    // Create mock Supabase client
    mockSupabase = SupabaseClient(
      'https://mock.supabase.co',
      'fake-key',
      httpClient: mockHttpClient,
    );

    remoteDataSource = SupabaseProjectRemoteDataSource(supabase: mockSupabase);
  });

  tearDown(() {
    mockHttpClient.reset();
  });

  group('fetchProjects', () {
    test('returns list of projects when successful', () async {
      final mockProjects = [
        {
          'id': '123',
          'name': 'Test Project',
          'created_at': '2024-01-23T00:00:00.000Z',
          'updated_at': '2024-01-23T00:00:00.000Z',
        },
        {
          'id': '456',
          'name': 'Another Project',
          'created_at': '2024-01-23T00:00:00.000Z',
          'updated_at': '2024-01-23T00:00:00.000Z',
        }
      ];

      // Insert mock data
      await mockSupabase.from('projects').insert(mockProjects);

      final result = await remoteDataSource.fetchProjects();

      expect(result.length, 2);
      expect(result[0].id, '123');
      expect(result[0].name, 'Test Project');
      expect(result[1].id, '456');
      expect(result[1].name, 'Another Project');
    });

    test('returns empty list when no projects exist', () async {
      final result = await remoteDataSource.fetchProjects();
      expect(result, isEmpty);
    });

    test('skips invalid projects and returns valid ones', () async {
      final mockProjects = [
        {
          'id': '1',
          'name': 'First Project',
          'created_at': '2024-01-23T00:00:00.000Z',
          'updated_at': '2024-01-23T00:00:00.000Z',
        },
        {
          'id': '2',
          'name': null, // Invalid project missing required name
          'created_at': '2024-01-23T00:00:00.000Z',
          'updated_at': '2024-01-23T00:00:00.000Z',
        },
        {
          'id': '3',
          'name': 'Third Project',
          'created_at': '2024-01-23T00:00:00.000Z',
          'updated_at': '2024-01-23T00:00:00.000Z',
        },
        {
          'id': '4',
          'name': 'Fourth Project',
          'created_at': '2024-01-23T00:00:00.000Z',
          'updated_at': '2024-01-23T00:00:00.000Z',
        },
      ];

      await mockSupabase.from('projects').insert(mockProjects);

      final result = await remoteDataSource.fetchProjects();

      expect(result.length, 3); // Only valid projects
      expect(result[0].id, '1');
      expect(result[1].id, '3');
      expect(result[2].id, '4');
      expect(result.any((project) => project.id == '2'), isFalse);
    });
  });

  group('getProjectById', () {
    test('returns project when found', () async {
      final mockProject = {
        'id': 'test-id',
        'name': 'Test Project',
        'created_at': '2024-01-23T00:00:00.000Z',
        'updated_at': '2024-01-23T00:00:00.000Z',
      };

      await mockSupabase.from('projects').insert([mockProject]);

      final result = await remoteDataSource.getProjectById('test-id');

      expect(result.id, 'test-id');
      expect(result.name, 'Test Project');
    });

    test(
      'throws exception when project not found',
      () async {
        await mockSupabase.from('projects').insert([]);

        expect(
          () => remoteDataSource.getProjectById('non-existent-id'),
          throwsA(isA<PostgrestException>()),
        );
      },
      skip: 'TODO: fix this test',
    );
  });
}
