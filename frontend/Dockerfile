FROM cirrusci/flutter:latest

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/frontend
COPY . .
RUN flutter pub get

ARG API_URL
ENV API_URL=${API_URL}

ENTRYPOINT []
CMD ["flutter", "build", "web"]
