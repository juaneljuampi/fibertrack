package cl.fibertrack.user;
import jakarta.persistence.*; import lombok.*; import java.time.*; import java.util.*;
@Entity @Table(name="usuarios") @Getter @Setter @NoArgsConstructor
public class User {
 @Id @GeneratedValue(strategy=GenerationType.UUID) private UUID id;
 private String nombre; private String apellido; private String email;
 @Column(name="password_hash") private String passwordHash;
 @Column(name="credential_status") private String credentialStatus="PENDIENTE";
 private boolean activo=true;
 @Column(name="is_owner") private boolean owner;
 @Column(name="protected_account") private boolean protectedAccount;
 @Column(name="deleted_at") private Instant deletedAt;
 @ManyToMany(fetch=FetchType.EAGER) @JoinTable(name="usuarios_roles",joinColumns=@JoinColumn(name="usuario_id"),inverseJoinColumns=@JoinColumn(name="rol_id")) private Set<Role> roles=new HashSet<>();
 @ManyToMany(fetch=FetchType.EAGER) @JoinTable(name="usuarios_permisos",joinColumns=@JoinColumn(name="usuario_id"),inverseJoinColumns=@JoinColumn(name="permiso_id")) private Set<Permission> permissions=new HashSet<>();
 public Set<String> effectivePermissions(){ if(owner) return Set.of("*"); var out=new HashSet<String>(); permissions.forEach(p->out.add(p.getCodigo())); roles.forEach(r->r.getPermissions().forEach(p->out.add(p.getCodigo()))); return out; }
}

