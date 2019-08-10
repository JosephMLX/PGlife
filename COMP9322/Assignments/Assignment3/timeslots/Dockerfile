FROM python:alpine3.7

RUN apk add --no-cache python3-dev
RUN pip install --upgrade pip

WORKDIR /demo

COPY . /demo

RUN pip3 install -r requirements.txt

EXPOSE 8010

CMD python3 ./demo/__init__.py