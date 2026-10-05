package cl.fibertrack.user;
import org.springframework.data.jpa.repository.JpaRepository; import java.util.*;
public interface PermissionRepository extends JpaRepository<Permission,UUID> { Set<Permission> findByCodigoIn(Collection<String> codigos); }

