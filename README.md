# Cobra

## Setup

```
$ git clone [...]
$ cd cobra
$ bundle
$ psql postgres
  # create user cobra with password '' CREATEDB;
  # \q
$ cp config/database.example.yml config/database.yml
$ rake db:create db:migrate
```
