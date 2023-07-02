ARG IMAGE=intersystemsdc/irishealth-community:latest
FROM $IMAGE

ARG OPENAI_API_KEY
ENV OPENAI_API_KEY=$OPENAI_API_KEY

WORKDIR /home/irisowner/irisdev

# run iris and initial 
RUN --mount=type=bind,src=.,dst=. \
    pip3 install -r requirements.txt && \
    iris start IRIS && \
	iris session IRIS < iris.script && \
    iris stop IRIS quietly
