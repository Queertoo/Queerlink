Queerlink
=========

Version 2


Queerlink is a simple yet efficient URL shortening service written in [Elixir](http://elixir-lang.org).
I needed such a service for [Alher](https://github.com/Queertoo/Alher)'s Tumblr plugin, so here it is.

#### TODO

* Learn Lua (again?) to generate a bunch of different URLs for `wrk`
* Maybe thinking about a mechanism to block incoming requests from an IP that would abuse of this service.


### Basics

#### Shortening

See `JSON API`.

#### Redirections

Just hit `/<ID>` and you'll get redirected.

### Installing

```
(export MIX_ENV=prod)
mix do deps.get, compile
mix ecto.migrate -r Queerlink.Repo
```

Fire up the webserver with `mix.server` (or `iex -S mix server` if you want to have access to an interactive conseole)

It will run by default on port 4000. Edit [config.exs](config/config.exs) to change it according to your needs. The IP it binds to is also configurable.

### Ngnix configuration

There are sample configuration files in the [nginx](nginx/) directory.  
The rate-limit is handled here.

### JSON API
#### Sending a link

`PUT /shorten/json?url='URL'`

```
$ http -j PUT "http://localhost:4000/shorten/json?url=http://github.com/foo/bar"
HTTP/1.1 200 OK
cache-control: max-age=0, private, must-revalidate
content-length: 36
content-type: application/json
date: Sat, 24 Oct 2015 18:44:07 GMT
server: Cowboy

{
    "data": "localhost/0",
    "status": "ok"
}
```

#### Retrieving a URL by its ID

```
$ http GET "http://localhost:4000/expand/json/0"
HTTP/1.1 200 OK
cache-control: max-age=0, private, must-revalidate
content-length: 50
content-type: application/json; charset=utf-8
date: Sat, 24 Oct 2015 18:46:57 GMT
server: Cowboy

{
    "data": "http://github.com/foo/bar",
    "status": "ok"
}

```

### Implementations
#### Clients

* [Queerlink-Client](https://github.com/EtienneDesticourt/Queerlink-Client): A basic python implementation.
