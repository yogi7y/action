extension ListExtension on List<Object?> {
  List<T> tryMap<T>(T Function(Map<String, Object?> map) fromMap) {
    return where((e) => e != null)
        .map((e) {
          try {
            return fromMap(e! as Map<String, Object?>);
          } catch (error) {
            return null;
          }
        })
        .whereType<T>()
        .toList();
  }
}
