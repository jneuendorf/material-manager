FROM python:3.11

RUN apt-get update && apt-get install -y --no-install-recommends
RUN mkdir -p /usr/pip/src
RUN pip install gunicorn

WORKDIR /usr/src/backend
COPY . .

RUN pip install --src /usr/pip/src/ --no-cache-dir -r requirements.txt

EXPOSE 8000
CMD ["./start-gunicorn.sh"]
