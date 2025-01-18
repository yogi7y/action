import 'package:flutter/material.dart';

import '../../../modules/projects/domain/entity/project.dart';
import '../../../modules/projects/presentation/screens/project_detail_screen.dart';
import '../../../modules/projects/presentation/state/project_detail_provider.dart';
import '../../exceptions/route_exception.dart';
import '../route_data.dart';
import 'route_handler.dart';

@immutable
class ProjectDetailRouteHandler extends RouteHandler<ProjectOrId> {
  @override
  Widget build(BuildContext context, ProjectOrId param) => ProjectDetailScreen(projectOrId: param);

  @override
  ProjectOrId validateAndTransform({
    required AppRouteData data,
  }) {
    final route = data.uri.toString();
    final extra = data.extra;

    if (extra is! ProjectEntity?)
      throw RouteException(
        exception: 'Data must be of type ProjectEntity or null',
        stackTrace: StackTrace.current,
        route: data.uri.toString(),
        uri: data.uri,
        details: {
          'projectData': extra,
          'type': extra.runtimeType,
        },
      );

    final id = data.pathParameters!['id'];

    if (extra == null && id == null)
      throw RouteException(
        exception: 'Either project data or ID is required',
        stackTrace: StackTrace.current,
        route: route,
        uri: data.uri,
        details: {
          'projectData': extra,
          'id': id,
        },
      );

    final projectOrId = (
      id: id,
      value: extra,
    );

    return projectOrId;
  }
}
