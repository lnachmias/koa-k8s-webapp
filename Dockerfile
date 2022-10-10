FROM node:alpine
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install koa
COPY . ./
EXPOSE 3000
CMD npm run start