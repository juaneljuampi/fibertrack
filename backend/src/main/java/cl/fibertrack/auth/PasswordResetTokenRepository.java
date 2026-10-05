package cl.fibertrack.auth;
import org.springframework.data.jpa.repository.JpaRepository; import java.util.*;
public interface PasswordResetTokenRepository extends JpaRepository<PasswordResetToken,UUID>{ Optional<PasswordResetToken> findByTokenHashAndUsedAtIsNullAndRevokedAtIsNull(String hash); List<PasswordResetToken> findByUserIdAndUsedAtIsNullAndRevokedAtIsNull(UUID userId); }

