package cl.fibertrack.user;
import cl.fibertrack.audit.AuditService; import cl.fibertrack.auth.AuthService; import cl.fibertrack.common.ApiException; import cl.fibertrack.security.PrincipalUser; import org.junit.jupiter.api.*; import org.mockito.*; import java.util.*; import static org.assertj.core.api.Assertions.*; import static org.mockito.Mockito.*;
class OwnerProtectionTest {
 @Mock UserRepository users; @Mock RoleRepository roles; @Mock PermissionRepository permissions; @Mock AuthService auth; @Mock AuditService audit; AutoCloseable mocks; UserAdminController controller; PrincipalUser admin;
 @BeforeEach void setUp(){mocks=MockitoAnnotations.openMocks(this);controller=new UserAdminController(users,roles,permissions,auth,audit);admin=new PrincipalUser(UUID.randomUUID(),"admin@test.cl","x",true,false,List.of());}
 @AfterEach void close()throws Exception{mocks.close();}
 @Test void adminCannotDeactivateOwner(){var owner=new User();owner.setId(UUID.randomUUID());owner.setOwner(true);owner.setProtectedAccount(true);when(users.findById(owner.getId())).thenReturn(Optional.of(owner));assertThatThrownBy(()->controller.deactivate(owner.getId(),admin)).isInstanceOf(ApiException.class).hasMessage("La cuenta OWNER está protegida");assertThat(owner.isActivo()).isTrue();verify(audit).record(eq(admin.id()),eq("INTENTO_DESACTIVAR_OWNER"),eq("USUARIO"),eq(owner.getId()),anyString(),eq("DENEGADO"));}
 @Test void adminCannotDeleteOwner(){var owner=new User();owner.setId(UUID.randomUUID());owner.setOwner(true);owner.setProtectedAccount(true);when(users.findById(owner.getId())).thenReturn(Optional.of(owner));assertThatThrownBy(()->controller.delete(owner.getId(),admin)).isInstanceOf(ApiException.class);assertThat(owner.getDeletedAt()).isNull();}
}
