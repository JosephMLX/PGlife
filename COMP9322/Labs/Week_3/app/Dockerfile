FROM python:alpine3.7

RUN apk add --no-cache python3-dev
RUN pip3 install --upgrade pip

WORKDIR /app

COPY . /app

RUN pip3 install -r requirements.txt

EXPOSE 5000

CMD python3 ./demo/__init__.py