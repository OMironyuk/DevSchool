FROM ubuntu:18.04
WORKDIR /opt/webapp
COPY requirements.txt /tmp
RUN apt update && DEBIAN_FRONTEND=noninteractive apt-get install -y -q python-all python-pip
RUN pip install -qr /tmp/requirements.txt
COPY . /opt/webapp
EXPOSE 5000
CMD ["python","app.py"]