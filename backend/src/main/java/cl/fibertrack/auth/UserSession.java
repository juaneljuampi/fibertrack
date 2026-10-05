package cl.fibertrack.auth;
import jakarta.persistence.*; import lombok.*; import cl.fibertrack.user.User; import java.time.*; import java.util.*;
@Entity @Table(name="user_sessions") @Getter @Setter @NoArgsConstructor
public class UserSession { @Id private UUID id; @ManyToOne @JoinColumn(name="usuario_id") private User user; @Column(name="refresh_token_hash") private String refreshTokenHash; @Column(name="created_at",insertable=false,updatable=false) private Instant createdAt; @Column(name="expires_at") private Instant expiresAt; @Column(name="last_used_at") private Instant lastUsedAt; @Column(name="revoked_at") private Instant revokedAt; @Column(name="device_name") private String deviceName; @Column(name="device_platform") private String devicePlatform; }

