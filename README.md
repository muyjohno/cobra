# Cobra

## Requirements
To deploy Cobra, you only need Docker Compose and a way of getting the repository onto your server (such as git).

For local development, you will need:
- Ruby 2.4.2 (or a Ruby version manager - e.g. rvm or rbenv - with access to 2.4.2)
- Bundler  
```
$ gem install bundler
```
- Postgres
- Git

## Deploy as a web server
- Get the project  
```
$ git clone https://github.com/muyjohno/cobra.git
$ cd cobra
```
- Deploy  
```
$ docker-compose up
```

## Set up for local development
- Get the project  
```
$ git clone https://github.com/muyjohno/cobra.git
$ cd cobra
```
- Install dependencies
```
$ bundle
```
- Set up config files
```
$ cp config/database.example.yml config/database.yml
$ cp config/secrets.example.yml config/secrets.yml
```
- Set up database
```
$ psql postgres
    # create user cobra with password '' CREATEDB;
    # \q
$ rake db:create db:migrate
```
- Start local server
```
$ rails server
```

## Run tests
```
$ rspec
```
