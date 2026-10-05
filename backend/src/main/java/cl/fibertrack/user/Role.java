package cl.fibertrack.user;
import jakarta.persistence.*; import lombok.*; import java.util.*;
@Entity @Table(name="roles") @Getter @Setter @NoArgsConstructor
public class Role { @Id @GeneratedValue(strategy=GenerationType.UUID) private UUID id; private String codigo; private String nombre; @ManyToMany(fetch=FetchType.EAGER) @JoinTable(name="roles_permisos",joinColumns=@JoinColumn(name="rol_id"),inverseJoinColumns=@JoinColumn(name="permiso_id")) private Set<Permission> permissions=new HashSet<>(); }

