package cl.fibertrack.auth;
import jakarta.persistence.*; import lombok.*; import cl.fibertrack.user.User; import java.time.*; import java.util.*;
@Entity @Table(name="password_reset_tokens") @Getter @Setter @NoArgsConstructor
public class PasswordResetToken { @Id @GeneratedValue(strategy=GenerationType.UUID) private UUID id; @ManyToOne @JoinColumn(name="usuario_id") private User user; @Column(name="token_hash") private String tokenHash; @Column(name="created_at",insertable=false,updatable=false) private Instant createdAt; @Column(name="expires_at") private Instant expiresAt; @Column(name="used_at") private Instant usedAt; @Column(name="revoked_at") private Instant revokedAt; }

