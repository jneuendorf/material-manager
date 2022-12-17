FROM python:3.11

RUN apt-get update && apt-get install -y --no-install-recommends
RUN mkdir -p /usr/pip/src
# gunicorn = production server, gdown => create sample data
RUN pip install gunicorn gdown

WORKDIR /usr/src/backend
COPY . .

RUN pip install --src /usr/pip/src/ --no-cache-dir -r requirements.txt
# Not `make sample_data` because no venv
RUN flask create-sample-data user material inspection rental

EXPOSE 8000
CMD ["./start-gunicorn.sh"]
