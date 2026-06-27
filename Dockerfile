# Stage 1: Build
FROM node:22-alpine AS builder

WORKDIR /app

# Install build tools untuk better-sqlite3
RUN apk add --no-cache python3 make g++

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

# Stage 2: Production
FROM node:22-alpine

WORKDIR /app

# Install Python di image production
RUN apk add --no-cache python3

COPY package*.json ./

RUN npm install --omit=dev

COPY --from=builder /app/dist ./dist

EXPOSE 3000

CMD ["node", "dist/main"]