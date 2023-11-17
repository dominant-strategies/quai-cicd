FROM node:14

WORKDIR /app

COPY ./ .

ARG BUILD_ENV

RUN echo building $BUILD_ENV

RUN npm install

RUN BUILD_ENV=$BUILD_ENV npm run build

CMD ["npm", "start"]

