FROM		ubuntu
RUN		apt-get update	\
		&& apt-get install -y curl gcc
ENV		GO_VERSION	1.11.1
WORKDIR		/opt
RUN		ARCH=$(uname -m | sed -e 's/x86_64/amd64/g')	\
		&& curl -s https://dl.google.com/go/go$GO_VERSION.linux-$ARCH.tar.gz | tar xz	\
		&& mv go go-bootstrap
ENV		GOROOT_BOOTSTRAP	/opt/go-bootstrap
WORKDIR		go
COPY		./ .
WORKDIR		src
RUN		./make.bash
WORKDIR		../..
CMD		tar cz go
