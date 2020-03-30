FROM ubuntu:latest

ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_DEFAULT_REGION

ENV AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
ENV AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
ENV AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}

COPY . /code/

WORKDIR /code/

RUN apt-get update -y && \
    apt-get install wget -y && \
    apt-get install unzip -y && \
    apt-get install awscli -y && \
    apt-get install openssh-client -y && \
    wget https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip &&  \
    unzip terraform_0.12.24_linux_amd64.zip && \
    mv terraform  /usr/local/bin/ && \
    ssh-keygen -t rsa -b 2048 -v -N '' -f ~/.ssh/terraform && \
    terraform init && \
    terraform validate && \
    terraform apply -auto-approve