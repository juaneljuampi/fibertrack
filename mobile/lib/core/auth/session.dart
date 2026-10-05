class SessionUser {
  SessionUser(
      {required this.id,
      required this.nombre,
      required this.email,
      required this.owner,
      required this.roles,
      required this.permissions});
  final String id, nombre, email;
  final bool owner;
  final Set<String> roles, permissions;
  factory SessionUser.fromJson(Map<String, dynamic> j) => SessionUser(
      id: j['id'],
      nombre: j['nombre'],
      email: j['email'],
      owner: j['owner'] ?? false,
      roles: Set<String>.from(j['roles'] ?? []),
      permissions: Set<String>.from(j['permissions'] ?? []));
  bool has(String permission) =>
      owner || permissions.contains('*') || permissions.contains(permission);
}
