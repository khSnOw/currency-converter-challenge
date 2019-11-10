default: init

init: reset-containers up

# Removes all the containers
reset-containers:
	# Dash in front of the command means ignore the exit status of the command that is executed (normally, a non-zero exit status would stop that part of the build).
	-docker-compose down --rmi=local --volumes --remove-orphans

# Starts the app locally
up:
	docker-compose up -d

# Starts the app locally in live reload mode
watch-files:
	docker-compose exec web rerun 'rackup -o 0.0.0.0 -p 9191'

# run tests
test:
	docker-compose exec web rspec

# connect to the web container terminal
ssh:
	docker-compose exec web /bin/bash
