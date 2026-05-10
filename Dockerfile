# Stage 1: "Builder" (Cumpliendo IE1 multi-stage build)
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# Stage 2: Producción
FROM node:18-alpine
WORKDIR /app

# Copiar dependencias y codigo desde el builder
COPY --from=builder /app/node_modules ./node_modules
COPY . .

# Configurar permisos para usuario no-root
RUN chown -R node:node /app

# Usar el usuario interno de la imagen node (no-root) para cumplir IE1
USER node

EXPOSE 3001
CMD ["npm", "start"]
