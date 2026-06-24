# Stage 1: "Builder" (Etapa de compilación/instalación)
# Usamos Node.js basado en Alpine Linux porque es muy ligero.
FROM node:18-alpine AS builder

# Declaramos que la carpeta de trabajo es /app
WORKDIR /app

# Copiamos los archivos package.json y package-lock.json para gestionar dependencias
COPY package*.json ./

# Instalamos únicamente las dependencias de producción (omite dependencias de desarrollo)
RUN npm install --production

# Stage 2: Producción (Etapa final)
# Usamos una nueva capa de Node.js Alpine totalmente limpia
FROM node:18-alpine

# Declaramos nuevamente la carpeta de trabajo
WORKDIR /app

# Copiamos la carpeta de dependencias (node_modules) generada en la etapa "Builder"
COPY --from=builder /app/node_modules ./node_modules

# Copiamos el resto del código fuente del backend (server.js, etc.) al contenedor
COPY . .

# Ajustamos los permisos de todos los archivos copiados para que pertenezcan al usuario "node"
RUN chown -R node:node /app

# Instruimos a Docker para que corra el proceso de Node.js utilizando el usuario no privilegiado "node"
# Esto previene que un atacante gane acceso root si vulnera la aplicación
USER node

# Exponemos el puerto 3001, que es donde escucha nuestra API Express
EXPOSE 3001

# Comando por defecto para iniciar nuestro servidor web de Node.js
CMD ["npm", "start"]
