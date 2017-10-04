FROM		ubuntu
RUN		apt-get update	\
		&& apt-get install -y curl gcc
ENV		GO_VERSION	1.9
WORKDIR		/opt
RUN		MACH=$(uname -m)	\
		&& if [ "$MACH" = "x86_64" ]; then ARCH=amd64; else ARCH=$MACH; fi	\
		&& curl -s https://storage.googleapis.com/golang/go$GO_VERSION.linux-$ARCH.tar.gz | tar xz	\
		&& mv go go-bootstrap
ENV		GOROOT_BOOTSTRAP	/opt/go-bootstrap
WORKDIR		go
COPY		./ .
WORKDIR		src
RUN		./make.bash
WORKDIR		../..
CMD		tar cz go
