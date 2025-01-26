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
        _createMockProject(
          id: '123',
          name: 'Test Project',
          dueDate: '2024-02-23T00:00:00.000Z',
        ),
        _createMockProject(
          id: '456',
          name: 'Another Project',
          status: 'done',
        ),
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
        _createMockProject(id: '1', name: 'First Project'),
        {
          'id': '2',
          'name': null, // Invalid project missing required name
          'created_at': '2024-01-23T00:00:00.000Z',
          'updated_at': '2024-01-23T00:00:00.000Z',
        },
        _createMockProject(id: '3', name: 'Third Project'),
        _createMockProject(id: '4', name: 'Fourth Project'),
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
      final mockProject = _createMockProject(
        id: 'test-id',
        name: 'Test Project',
      );

      await mockSupabase.from('projects').insert([mockProject]);

      final result = await remoteDataSource.getProjectById('test-id');

      expect(result.id, 'test-id');
      expect(result.name, 'Test Project');
    });
  });
}

Map<String, Object?> _createMockProject({
  required String id,
  required String name,
  String status = 'not_started',
  String? dueDate,
  String createdAt = '2024-01-23T00:00:00.000Z',
  String updatedAt = '2024-01-23T00:00:00.000Z',
}) {
  return {
    'id': id,
    'name': name,
    'status': status,
    if (dueDate != null) 'due_date': dueDate,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
