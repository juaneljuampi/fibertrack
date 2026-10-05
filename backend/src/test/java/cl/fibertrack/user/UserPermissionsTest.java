package cl.fibertrack.user;
import org.junit.jupiter.api.Test; import static org.assertj.core.api.Assertions.*;
class UserPermissionsTest {
 @Test void combinesRoleAndDirectPermissionsWithoutDuplicates(){var rolePermission=new Permission();rolePermission.setCodigo("FUSION_CREAR");var direct=new Permission();direct.setCodigo("CERTIFICACION_APROBAR");var role=new Role();role.setCodigo("FUSIONADOR");role.getPermissions().add(rolePermission);var user=new User();user.getRoles().add(role);user.getPermissions().add(rolePermission);user.getPermissions().add(direct);assertThat(user.effectivePermissions()).containsExactlyInAnyOrder("FUSION_CREAR","CERTIFICACION_APROBAR");}
 @Test void ownerReceivesWildcard(){var user=new User();user.setOwner(true);assertThat(user.effectivePermissions()).containsExactly("*");}
}

