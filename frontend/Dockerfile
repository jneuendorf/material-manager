FROM cirrusci/flutter:latest

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/frontend
COPY . .
RUN flutter pub get

ARG API_URL
ENV API_URL=${API_URL}

ENTRYPOINT []
RUN echo "flutter build web --dart-define API_URL=${API_URL}"
# --tree-shake-icons is not yet available for web
CMD flutter build web --dart-define API_URL=${API_URL}
