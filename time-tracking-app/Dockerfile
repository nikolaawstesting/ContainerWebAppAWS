# Stage 1: Build the Vue.js application
FROM node:22 AS build-stage

WORKDIR /app

COPY ./time-tracking-app/package*.json ./

RUN cat ./package.json

RUN npm install

COPY ./time-tracking-app/* .

RUN pwd
RUN ls

RUN npm run build
# Stage 2: Serve the application with Nginx
FROM nginx:alpine

# Copy built files from the build stage
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Copy Nginx configuration
COPY ./time-tracking-app/nginx.conf /etc/nginx/nginx.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]