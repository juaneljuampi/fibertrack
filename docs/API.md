# API REST

Base local: `http://localhost:8080/api/v1`. Swagger: `/swagger-ui.html`.

- Auth: `POST /auth/login`, `/auth/refresh`, `/auth/logout`, `/auth/password/request`, `/auth/password/reset`, `/auth/password/change`; `GET /auth/me`.
- Administración: `GET/POST /usuarios`, `POST /usuarios/{id}/desactivar`, `DELETE /usuarios/{id}`.
- Red: `/proyectos`, `/proyectos/{id}/cabeceras`, `/cabeceras/{id}/sectores`, `/sectores/{id}`, `/posiciones/{id}/asignacion`, `/posiciones/{id}/trazabilidad`.
- Cable: `POST /proyectos/{id}/cables/48`, `GET /cables/{id}/fibras`.
- Certificación: `POST/GET /certificaciones`, `PUT /certificaciones/{id}/mediciones`, acciones aprobar/rechazar/anular y `GET /certificaciones/{id}/pdf`.

Los errores tienen `timestamp`, `status`, `error` y `message`. Login y password request no revelan si un correo desconocido existe.

