FROM cirrusci/flutter:latest

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/frontend
COPY . .
RUN flutter pub get

ARG API_URL
# Ensure API_URL is set at build time as expected by api.dart
RUN grep "API_URL=${API_URL}" env/.env || grep "API_URL=${API_URL}" env/dev.env

ENTRYPOINT []
# --tree-shake-icons is not yet available for web
CMD flutter build web
