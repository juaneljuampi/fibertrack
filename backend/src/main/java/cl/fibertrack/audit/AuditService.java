package cl.fibertrack.audit;
import org.springframework.jdbc.core.JdbcTemplate; import org.springframework.stereotype.Service; import java.util.*;
@Service public class AuditService { private final JdbcTemplate db; public AuditService(JdbcTemplate db){this.db=db;} public void record(UUID uid,String action,String entity,Object id,String description,String result){db.update("INSERT INTO auditoria(usuario_id,accion,entidad,entidad_id,descripcion,resultado) VALUES (?,?,?,?,?,?)",uid,action,entity,id==null?null:id.toString(),description,result);} }

