package cl.fibertrack.user;
import jakarta.persistence.*; import lombok.*; import java.util.*;
@Entity @Table(name="permisos") @Getter @Setter @NoArgsConstructor
public class Permission { @Id @GeneratedValue(strategy=GenerationType.UUID) private UUID id; private String codigo; private String descripcion; }

