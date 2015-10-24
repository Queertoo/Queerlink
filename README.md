Queerlink
=========
Queerlink is a simple yet efficient URL shortening service written in [Elixir](http://elixir-lang.org).
I needed such a service for [Alher](https://github.com/Queertoo/Alher)'s Tumblr plugin, so here it is.

### Basics

#### Shortening

See `JSON API`.

#### Redirections

Just hit /<ID> and you'll get redirected.

### Installing

```
mix deps.get
MIX_ENV=prod compile
MIX_ENV=prod mix.server
```

It will run by default on port 4000. Edit [config.exs](config/config.exs) to change it according to your needs. The host is also configurable.

### JSON API
#### Sending a link

`POST /shorten/json?url='URL'`

```
$ http -j POST "http://localhost:4000/shorten/json?url=http://github.com/foo/bar"
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
