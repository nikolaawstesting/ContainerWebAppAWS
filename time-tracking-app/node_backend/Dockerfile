
FROM node:22

WORKDIR /app

COPY ./time-tracking-app/node_backend/package*.json ./

RUN npm install

COPY ./time-tracking-app/node_backend .

RUN npm install pm2 -g

USER node

EXPOSE 3000

CMD ["pm2-runtime", "index.js"]