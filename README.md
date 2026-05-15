# Backend - Tienda de Perritos

Este repositorio contiene la capa de lógica de negocio (Nivel 2) de la arquitectura de tres niveles de la aplicación web "Tienda de Perritos".

## Descripción

Consiste en una API REST construida con Node.js y Express, diseñada para interactuar con la base de datos MySQL (Nivel 3). Por razones de seguridad de infraestructura, este componente debe estar desplegado en una **subred privada** en AWS, sin una IP pública asignada, recibiendo únicamente tráfico proveniente del Proxy Inverso del Frontend a través del puerto `3001`.

## Archivos Principales

- `server.js`: Archivo principal del servidor Node.js que define las rutas de la API, maneja las consultas y establece la conexión con la base de datos mediante variables de entorno (`DB_HOST`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`).
- `package.json`: Manejador de dependencias del proyecto de Node.js.
- `Dockerfile`: Orquesta la creación de la imagen del contenedor del backend aplicando estándares de la industria:
  - **Multi-stage build (`AS builder`)**: Compila las dependencias omitiendo paquetes innecesarios en la imagen final.
  - **Ejecución No-Root**: Se asegura de que el proceso principal de Node se ejecute bajo el usuario sin privilegios `node`, mitigando riesgos de seguridad en caso de vulnerabilidades de dependencias.

## Flujo de Trabajo y Despliegue

1. **Desarrollo:** Cualquier cambio a la API o lógica de controladores se realiza en `server.js`.
2. **Pruebas Locales:** Puedes usar `docker-compose.yml` para levantar todo el entorno junto a una BD de pruebas localmente.
3. **CI/CD:** Cuando termines de programar y haces un `push` a la rama `deploy`, se activará el flujo de trabajo de GitHub Actions (`.github/workflows/main.yml`).
   - El código se empaquetará en una nueva imagen Docker.
   - Se almacenará en Amazon ECR de manera privada.
   - El agente de AWS SSM (Systems Manager) de la instancia EC2 recibirá la orden segura para reemplazar el contenedor antiguo e inyectarle las credenciales correspondientes a la BD privada de AWS.

> **Nota:** Este archivo `README.md` es exclusivo para documentación del repositorio. No afecta al pipeline CI/CD (GitHub Actions ignora los push de este archivo) ni es empaquetado en el contenedor Docker.
