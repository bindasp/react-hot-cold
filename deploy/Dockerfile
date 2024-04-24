FROM node

WORKDIR /app

COPY ./artifacts .

RUN npm install -g serve
CMD serve -s build
