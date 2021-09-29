all:
	docker run -it --name owasp-zap --rm -e DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix/ \
		-v ${PWD}/data/.ZAP:/home/zap/.ZAP \
		-v ${PWD}/data/.ZAP_D:/home/zap/.ZAP_D \
		-v ${PWD}/data/addons:/home/zap/addons \
		-p 8081:8081 \
		owasp/zap2docker-stable /zap/zap.sh
