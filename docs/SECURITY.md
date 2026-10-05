# Seguridad

No existe registro público. OWNER se crea idempotentemente desde `INITIAL_OWNER_EMAIL`; la contraseña es opcional y solo se toma del entorno en la primera creación. Si ya existe, el bootstrap no la cambia. Los DTO administrativos no exponen `isOwner` ni `protectedAccount`; cualquier intento destructivo contra una cuenta protegida retorna 403 y se audita.

Use un `JWT_SECRET` aleatorio de al menos 32 bytes. Access tokens duran 15 minutos por defecto; refresh tokens 30 días y son revocables por dispositivo. Desactivar al usuario invalida refresh y el filtro rechaza access posteriores. Reset de contraseña revoca todas las sesiones.

No registrar passwords, hashes ni tokens. En producción configure TLS, firewall, SMTP con secretos en `.env`, rotación de backups y acceso SSH por llave. PostgreSQL no publica puertos.

