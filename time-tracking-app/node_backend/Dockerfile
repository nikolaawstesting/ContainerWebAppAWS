
FROM node:22-alpine as builder
WORKDIR /app
COPY ./time-tracking-app/node_backend/package*.json ./
RUN npm install
COPY ./time-tracking-app/node_backend .
RUN npm run build
RUN npm prune --production

FROM node:22-alpine
WORKDIR /app
COPY --from=builder /app .
RUN npm install pm2 -g
USER node
EXPOSE 3000
CMD ["pm2-runtime", "index.js"]