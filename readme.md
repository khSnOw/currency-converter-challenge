### To Run Server Locally using docker ###

1. Download and install Docker
2. Install GNU Make if you don't have
3. Run `make` in your terminal

After the build the app is available at `http://localhost:8484/`

### Useful commands

1. To watch for files changes `make watch-files`.
2. To stop the containers run `make down`.
3. To start again run `make up`
6. Run tests `make test`


### To Run Server Locally using your host ###

1. Download and install the last version of ruby and bundle
2. run `bundle install`
3. point your application to your database, by default the application is configured to use MySql
4. run `rackup`

### Useful commands
1. to run tests `rspec`
