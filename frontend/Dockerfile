FROM node:20-alpine AS build
WORKDIR /app
COPY frontend/package*.json ./
RUN npm ci
COPY frontend/ ./
COPY TimeMem-PWA/manifest.json ./public/manifest.json
COPY TimeMem-PWA/sw.js ./public/sw.js
COPY TimeMem-PWA/index.html ./public/timemem-pwa-original.html
RUN npm run build

FROM nginx:1.27-alpine
COPY frontend/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
RUN printf 'ok' > /usr/share/nginx/html/healthz
EXPOSE 80
