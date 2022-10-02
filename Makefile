build:
	npm ci
	mkdir -p public
	cd flappy-bird; zip -9 -r ../flappy.love . -x ".DS_Store"
	npx love.js -t "Flappy Bird" -c flappy.love public

run html:
	python3 -m http.server 9000 --directory public