FROM node:14

WORKDIR /src

RUN npm i npm@6.14.5 -g

COPY . /src/

ENV NODE_ENV production

RUN npm install

ENV PATH /src/node_modules/.bin:$PATH

CMD ["node", "/src/main.js"]
