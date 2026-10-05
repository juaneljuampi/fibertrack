package cl.fibertrack.user;
import org.springframework.data.jpa.repository.*; import java.util.*;
public interface UserRepository extends JpaRepository<User,UUID> { Optional<User> findByEmailIgnoreCaseAndDeletedAtIsNull(String email); boolean existsByEmailIgnoreCaseAndDeletedAtIsNull(String email); }

