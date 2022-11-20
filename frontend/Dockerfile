FROM cirrusci/flutter:latest

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/frontend
COPY . .
RUN flutter pub get

ENTRYPOINT []
CMD ["flutter", "run", "-d", "chrome", "--web-port", "55542"]
