Queerlink
=========
Queerlink is a simple yet efficient URL shortening service written in [Elixir](http://elixir-lang.org).
I needed such a service for [Alher](https://github.com/Queertoo/Alher)'s Tumblr plugin, so here it is.

### Comment ça marche

Requête GET à /shorten/url


### API

#### Sending a link

GET /shorten/url_to_shorten

Then you'll get the following JSON document

```JSON
{
    "shortened_link":<Shortened URL>,
    "link":<Original Link>
    rtened_link\":\"hemochro.me/0\",\"link\":\"https://github.com\"}"
}
```
