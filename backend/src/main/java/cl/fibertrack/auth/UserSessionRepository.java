package cl.fibertrack.auth;
import org.springframework.data.jpa.repository.JpaRepository; import java.util.*;
public interface UserSessionRepository extends JpaRepository<UserSession,UUID>{ Optional<UserSession> findByRefreshTokenHashAndRevokedAtIsNull(String hash); List<UserSession> findByUserIdAndRevokedAtIsNull(UUID userId); }

