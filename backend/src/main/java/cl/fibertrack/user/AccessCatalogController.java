package cl.fibertrack.user;
import org.springframework.security.access.prepost.PreAuthorize; import org.springframework.web.bind.annotation.*; import java.util.*;
@RestController @RequestMapping("/api/v1") public class AccessCatalogController { private final RoleRepository roles; private final PermissionRepository permissions; public AccessCatalogController(RoleRepository roles,PermissionRepository permissions){this.roles=roles;this.permissions=permissions;}
 @GetMapping("/roles") @PreAuthorize("hasAuthority('ROL_VER') or hasAuthority('OWNER')") List<?> roles(){return roles.findAll().stream().map(r->Map.of("id",r.getId(),"codigo",r.getCodigo(),"nombre",r.getNombre(),"permisos",r.getPermissions().stream().map(Permission::getCodigo).sorted().toList())).toList();}
 @GetMapping("/permisos") @PreAuthorize("hasAuthority('PERMISO_VER') or hasAuthority('OWNER')") List<?> permissions(){return permissions.findAll().stream().map(p->Map.of("id",p.getId(),"codigo",p.getCodigo(),"descripcion",p.getDescripcion())).toList();}
}
