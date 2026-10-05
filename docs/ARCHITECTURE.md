# Arquitectura

FiberTrack es un monorepo con Flutter, una API REST Spring Boot 3/Java 21 y PostgreSQL. Nginx es el único servicio público en producción. El backend usa una arquitectura por funciones (`auth`, `user`, `domain`, `certification`, `audit`), DTOs en el límite HTTP y transacciones de servicio para invariantes.

El acceso usa JWT corto y un refresh opaco aleatorio. PostgreSQL conserva solo hashes SHA-256 de refresh y reset tokens. Flutter guarda ambos tokens en Android Keystore/iOS Keychain. Cada apertura muestra un splash mientras restaura y valida la sesión, evitando parpadeo del login.

Los roles agrupan permisos, los permisos directos se suman, y OWNER se resuelve desde flags persistidos. La interfaz mejora la experiencia ocultando acciones, pero `@PreAuthorize` decide siempre en el servidor.

La jerarquía principal es Proyecto → Cabecera → Sector (piso/lado) → Departamento → OP1/OP2 → Puerto. Crear un sector bloquea y reserva dos puertos libres por departamento dentro de una única transacción.

