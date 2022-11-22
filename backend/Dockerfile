FROM python:3.11

RUN apt-get update && apt-get install -y --no-install-recommends
RUN mkdir -p /usr/pip/src
RUN pip install gunicorn

WORKDIR /usr/src/backend
COPY . .

ARG CORE_PUBLIC_FRONTEND_URL
ARG CORE_PUBLIC_API_URL
ENV CORE_PUBLIC_FRONTEND_URL=${CORE_PUBLIC_FRONTEND_URL}
ENV CORE_PUBLIC_API_URL=${CORE_PUBLIC_API_URL}

RUN pip install --src /usr/pip/src/ --no-cache-dir -r requirements.txt
RUN make sample_data

EXPOSE 8000
CMD ["./start-gunicorn.sh"]
