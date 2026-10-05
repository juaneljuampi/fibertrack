package cl.fibertrack.domain;
import org.springframework.jdbc.core.simple.JdbcClient; import org.springframework.security.access.prepost.PreAuthorize; import org.springframework.web.bind.annotation.*; import java.util.*;
@RestController @RequestMapping("/api/v1") public class ReferenceController { private final JdbcClient db; public ReferenceController(JdbcClient db){this.db=db;}
 @GetMapping("/operadores") @PreAuthorize("hasAuthority('OPERADOR_VER') or hasAuthority('OWNER')") Object operators(){return db.sql("SELECT * FROM operadores WHERE activo ORDER BY nombre").query().listOfRows();}
 @GetMapping("/cables/{id}/fibras") @PreAuthorize("hasAuthority('FIBRA_VER') or hasAuthority('OWNER')") Object fibers(@PathVariable UUID id){return db.sql("SELECT f.*,t.numero tubo,t.color color_tubo FROM fibras f JOIN tubos t ON t.id=f.tubo_id WHERE t.cable_id=:id ORDER BY f.numero_global").param("id",id).query().listOfRows();}
 @GetMapping("/auditoria") @PreAuthorize("hasAuthority('AUDITORIA_VER') or hasAuthority('OWNER')") Object audit(){return db.sql("SELECT * FROM auditoria ORDER BY fecha DESC LIMIT 500").query().listOfRows();}
}
