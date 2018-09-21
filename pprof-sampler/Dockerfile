FROM		buildpack-deps:curl
RUN		apt-get update	\
		&& apt-get install -y	\
			jq
COPY		sampler.sh config.json	/
WORKDIR		/profiles/pprof
CMD		["/sampler.sh"]
