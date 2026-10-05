# Despliegue DigitalOcean

1. Cree un Droplet Ubuntu LTS, agregue una llave SSH y un usuario `deploy` con sudo.
2. En UFW permita `OpenSSH`, `80/tcp` y `443/tcp`; deniegue 5432.
3. Instale Docker Engine y el plugin Compose desde el repositorio oficial de Docker. Agregue `deploy` al grupo docker y vuelva a iniciar sesión.
4. Clone el repositorio en `/opt/fibertrack`, copie `.env.example` a `.env` y complete secretos. Genere `JWT_SECRET` con una fuente criptográfica. `INITIAL_OWNER_PASSWORD` puede usarse solo en el primer arranque y luego debe vaciarse.
5. Apunte el DNS A de `api.dominio.cl` al Droplet. Reemplace `${DOMAIN}` en la configuración Nginx mediante una plantilla (`envsubst`) o escriba el dominio final.
6. Obtenga el certificado inicial con Certbot usando `infra/certbot/www`; monte los archivos bajo `infra/certbot/conf` y levante `docker compose --env-file ../.env up -d --build` desde `infra`.
7. Verifique `docker compose ps`, `curl https://api.dominio.cl/actuator/health`, logs del backend y Swagger (restríjalo si la política lo exige).
8. Ejecute `infra/scripts/backup.sh` mediante cron y copie los `.sql.gz` cifrados fuera del Droplet. Pruebe `restore.sh` regularmente en un entorno aislado.
9. Para actualizar: haga backup, `git pull`, `docker compose build backend`, `docker compose up -d`; Flyway migra hacia adelante. Conserve la imagen anterior para rollback. No revierta una migración destructiva sin un restore probado.

La app se compila con `flutter build apk --dart-define=API_BASE_URL=https://api.dominio.cl/api/v1` (o `appbundle`/`ios`).
