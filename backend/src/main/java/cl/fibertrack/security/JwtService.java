package cl.fibertrack.security;
import cl.fibertrack.config.FiberTrackProperties; import io.jsonwebtoken.*; import io.jsonwebtoken.security.Keys; import org.springframework.stereotype.Service; import javax.crypto.SecretKey; import java.nio.charset.StandardCharsets; import java.time.*; import java.util.*;
@Service public class JwtService {
 private final FiberTrackProperties p; private final SecretKey key;
 public JwtService(FiberTrackProperties p){this.p=p; this.key=Keys.hmacShaKeyFor(Arrays.copyOf(p.jwt().secret().getBytes(StandardCharsets.UTF_8),32));}
 public String issue(PrincipalUser u){var now=Instant.now(); return Jwts.builder().subject(u.id().toString()).claim("email",u.email()).issuedAt(Date.from(now)).expiration(Date.from(now.plusSeconds(p.jwt().accessSeconds()))).signWith(key).compact();}
 public UUID subject(String token){return UUID.fromString(Jwts.parser().verifyWith(key).build().parseSignedClaims(token).getPayload().getSubject());}
 public long expiresIn(){return p.jwt().accessSeconds();}
}

