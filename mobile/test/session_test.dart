import 'package:flutter_test/flutter_test.dart';
import 'package:fibertrack/core/auth/session.dart';

void main() {
  test('owner and effective permissions authorize actions', () {
    final ordinary = SessionUser(
        id: '1',
        nombre: 'A',
        email: 'a@b.cl',
        owner: false,
        roles: {'FUSIONADOR'},
        permissions: {'FUSION_CREAR'});
    expect(ordinary.has('FUSION_CREAR'), isTrue);
    expect(ordinary.has('USUARIO_CREAR'), isFalse);
    final owner = SessionUser(
        id: '2',
        nombre: 'O',
        email: 'o@b.cl',
        owner: true,
        roles: {},
        permissions: {});
    expect(owner.has('ANY_PERMISSION'), isTrue);
  });
}
