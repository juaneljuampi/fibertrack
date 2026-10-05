# FiberTrack

Aplicación móvil y API para gestionar la trazabilidad completa de instalaciones de fibra óptica en edificios: proyecto, cabecera, piso/lado, departamento, OP1/OP2, puerto, operador, cable, tubo, fibra, fusión, medición y certificación.

## Componentes

- `mobile/`: Flutter + Material 3, sesión persistente en Keystore/Keychain, autorización por permisos y share sheet nativo para PDF.
- `backend/`: Java 21 + Spring Boot, Security/JWT, JPA, JDBC transaccional, Flyway, PDFBox, Swagger y Actuator.
- `infra/`: PostgreSQL, Docker Compose, Nginx TLS, backup/restore.
- `docs/`: arquitectura, esquema, API, seguridad y despliegue DigitalOcean.

## Inicio local

1. Copie `.env.example` a `.env`, establezca contraseñas y un `JWT_SECRET` aleatorio de 32 bytes o más.
2. Establezca `INITIAL_OWNER_PASSWORD` únicamente para crear la primera credencial de `juaneljuampi@gmail.com`.
3. Ejecute `docker compose --env-file ../.env up --build` desde `infra/`.
4. Compruebe `http://localhost:8080/actuator/health` si expone el backend directamente en desarrollo, o el host Nginx configurado.
5. Desde `mobile/`, ejecute `flutter pub get` y `flutter run --dart-define=API_BASE_URL=http://IP_LOCAL:8080/api/v1`.

No existe registro público. Los administradores crean usuarios sin contraseña; el trabajador usa el flujo crear/recuperar contraseña. El OWNER queda marcado en PostgreSQL como `is_owner` y `protected_account`; ningún DTO permite asignar esos flags y las operaciones destructivas se rechazan en backend.

## Reglas implementadas

- Roles múltiples y permisos efectivos (rol + permisos directos), validados con `@PreAuthorize`.
- Access JWT corto + refresh opaco por dispositivo; ambos flujos revisan que el usuario siga activo.
- Departamentos variables y no consecutivos. Cada departamento crea exactamente OP1 y OP2.
- Cabeceras de 94/144 puertos. Una transacción reserva dos puertos reales por departamento y rechaza capacidad insuficiente.
- Cable inicial de 48 fibras como seis tubos de ocho, colores y restricción de asignación activa única.
- Certificaciones numeradas por secuencia, mediciones 1310/1490/1550/LOG, estados auditables y PDF A4 multipágina generado desde la base.
- Flutter descarga el PDF oficial y abre el share sheet (WhatsApp, correo, Drive, etc.).
- PostgreSQL privado, healthchecks, proceso Java no-root, TLS en Nginx, backups comprimidos y guía de DigitalOcean.

## Verificación

Backend: `./mvnw test` y `./mvnw clean package` en `backend/` (los lanzadores requieren Maven 3.9+ del sistema). Mobile: `flutter pub get`, `flutter analyze`, `flutter test` en `mobile/`. El Dockerfile proporciona Maven/Java 21 reproducibles cuando no existe toolchain local.

Consulte [Arquitectura](docs/ARCHITECTURE.md), [Base de datos](docs/DATABASE.md), [API](docs/API.md), [Seguridad](docs/SECURITY.md) y [Despliegue](docs/DEPLOYMENT.md).
