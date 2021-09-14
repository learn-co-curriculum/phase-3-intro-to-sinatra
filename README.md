# Creating a Sinatra Application

## Learning Goals

- Understand how Sinatra simplifies developing web applications
- Receive a request in Sinatra and send different kinds of responses
- Create dynamic routes in Sinatra

## Introduction

> A web application framework (WAF) is a software framework that is designed to
> support the development of dynamic websites, web applications, web services
> and web resources. The framework aims to alleviate the overhead associated
> with common activities performed in web development.
> — [Wikipedia](https://en.wikipedia.org/wiki/Web_application_framework)

Building dynamic web applications in any language is a complex job requiring
intimate knowledge of hundreds of technologies and specifications. The good
news, however, is that many of these requirements are universal and every web
application must conform to these standards.

For example, any robust web application will need to handle **request routing**
and provide a mechanism for the application to respond to different URLs with
the appropriate **response**. For example, a blog application may handle a
request to `GET /posts` to show all the recent blog posts, and a request to
`GET /authors` to list all the authors.

Similarly, web applications require the ability to render templates to produce
consistently structured dynamic content. A request to `GET /posts/1` must render
the HTML for the first post, just as a request to `GET /posts/2` will render
identically structured HTML (but with different content) for the second post.
This is possible because of _templates_.

Web frameworks should also provide a way to send data back in a variety of
different formats. For example, we should be able to produce full HTML pages,
but we should also be able to produce simple JSON strings to represent the data
in our applications.

Web frameworks take all these routine and common requirements of any web
application and abstract them into code and patterns that provide these
functionalities to your application without requiring you to build them
yourself.

Frameworks provide structure and libraries that allow you to focus on **your**
application and not **applications in general**. The bigger the framework, the
more you can rely on it to provide you with common needs. The smaller the
framework, the more you'll have to build things yourself.

## What is Sinatra?

[Sinatra][sinatra] is a small web framework that provides a Domain Specific
Language (or DSL) implemented in Ruby. It was created by [Blake Mizerany](https://github.com/bmizerany)
and provides a lightweight option for developing simple web applications. Sinatra
is Rack-based, which means it uses Rack under the hood and can use many tools
designed to work with Rack. It's been used by companies such as Apple, BBC,
GitHub, LinkedIn, and more.

Essentially, Sinatra is nothing more than some pre-written methods that we can
include in our applications to turn them into Ruby web applications.

Unlike Ruby on Rails, which is a full-stack web development framework that
provides everything needed from front to back, Sinatra is designed to be
lightweight and flexible. It provides you with the bare minimum requirements
and abstractions for building simple and dynamic Ruby web applications.

In addition to being a great tool for certain projects, Sinatra is a great way
to get started in web application development with Ruby and will prepare you for
learning other larger frameworks, including Rails.

## Using Sinatra

To see what Sinatra is all about, let's build out a quick demo application.
First, run `bundle install` to install the Sinatra gem from the Gemfile. Then,
take a look at the code in the `config.ru` file:

```rb
require 'sinatra'

class App < Sinatra::Base

  get '/hello' do
    '<h2>Hello <em>World</em>!</h2>'
  end

end

run App
```

Run the app with:

```console
$ rackup config.ru
```

Just like with our Rack example, this will run a server locally. Visit
[http://localhost:9292/hello](http://localhost:9292/hello) in the browser to
make a request to our Sinatra server and see the response. It even takes care of
sending back the 200 status code, and setting the `Content-Type` header to
`text/html`, which we had to do manually with Rack. Nice!

Let's break down what's happening in this simple example, and then add a few
more features to our Sinatra server.

## Sinatra Routing

One of the biggest benefits of using Sinatra is that it has a very easy-to-read
Domain-Specific Language, or DSL, for writing multiple routes in an application.

In the `App` class above, we're inheriting this routing DSL from the
`Sinatra::Base` class, which allows us to define routes like this inside the
class:

```rb
get '/hello' do
  '<h2>Hello <em>World</em>!</h2>'
end
```

You can quickly see what this code is doing: it's setting up a **block of code**
that will run whenever a `GET` request comes in to the `/hello` path of our
application. Whatever is **returned** by the block will be sent back as the
response: in this case, it's a string representing some HTML.

We can also easily define more than one route:

```rb
class App < Sinatra::Base

  get '/hello' do
    '<h2>Hello <em>World</em>!</h2>'
  end

  get '/potato' do
    "<p>Boil 'em, mash 'em, stick 'em in a stew</p>"
  end

end
```

> **Note**: After making these changes, you'll need to restart the server before
> you can try them out in the browser. You can stop the server with `control + c`.
> If you encounter an error when running your server about the port being in use,
> refer to [this StackOverflow post](https://stackoverflow.com/a/32592965) to
> find and stop a process running on a specific port.

Compared to the conditional logic we needed to write by hand in Rack, we think
you'll agree that this DSL provides a much nicer developer experience!

Sinatra also provides friendlier error messages when your application doesn't
work as expected. For example, try visiting a route that doesn't exist, like
[http://localhost:9292/nope](http://localhost:9292/nope). You should see an
error screen, along with a suggestion on how to fix this particular error by
updating your code. Nice!

## Sending HTML and JSON Responses

Another feature of Sinatra that helps simplify our server-side code is the
ability to easily send back a response in different formats. For example, we can
have it send back some HTML dynamically by generating a string with Ruby:

```rb
class App < Sinatra::Base

  get '/dice' do
    dice_roll = rand(1..6)
    "<h2>You rolled a #{dice_roll}</h2>"
  end

end
```

Every time we make a request, we send back a different number in the HTML
string.

But what if instead of HTML, we wanted to have our application generate some
JSON data, which we could use with a separate frontend application like React?

Well, that's as easy as using the `.to_json` method to convert a Ruby hash or array
to a valid JSON string:

```rb
class App < Sinatra::Base

  get '/dice' do
    dice_roll = rand(1..6)
    { roll: dice_roll }.to_json
  end

end
```

We can also update the default response header for all responses to indicate
that our server is returning a JSON-formatted string:

```rb
class App < Sinatra::Base
  # Add this line to set the Content-Type header for all responses
  set :default_content_type, 'application/json'

  get '/dice' do
    dice_roll = rand(1..6)
    { roll: dice_roll }.to_json
  end

end
```

Now, restart the server and visit our new endpoint at
[http://localhost:9292/dice](http://localhost:9292/dice). Refresh the page to
your heart's content! You'll get some new JSON data each time.

## Dynamic Routing in Sinatra

One other powerful feature of Sinatra is the ability to define **dynamic
routes**.

To give a contrived example, let's say, for instance, that we were building an
API for performing math operations. When a request comes in to our server to the
path `/add/1/2`, we'd want to add 1 + 2 and send back a response of 3.

We could try setting this up like our other routes:

```rb
class App < Sinatra::Base

  get '/add/1/2' do
    sum = 1 + 2
    { result: sum }.to_json
  end

end
```

This works just fine for 1 and 2, but what if we want to add other numbers, like
`/add/2/5`? Well, we could try to define routes for those other numbers
manually, but... nope, that won't work. There are way too many numbers for that
to be practical!

What we can do instead is write out a route using a special syntax with **named
parameters**, which looks like this:

```rb
class App < Sinatra::Base

  # :num1 and :num2 are named parameters
  get '/add/:num1/:num2' do
    num1 = params[:num1].to_i
    num2 = params[:num2].to_i

    sum = num1 + num2
    { result: sum }.to_json
  end

end
```

By defining our route with this special syntax, any requests that match the
pattern `/add/:num1/:num2` will result in this route being used. So making a
request to `/add/1/2` will use this route, and so will `/add/2/5`.

The other benefit of using this syntax is that we get access to additional data
from the url in a special variable known as the **params hash**.

We'll explore the params hash in more detail in future lessons, but you can
think of it as a way for us to pass in some additional arguments to a route
handler.

For example, a `GET /add/1/2` request would result in a params hash that looks
like this:

```rb
{"num1"=>"1", "num2"=>"2"}
```

And a `GET /add/2/5` request would result in a params hash that looks
like this:

```rb
{"num1"=>"2", "num2"=>"5"}
```

While this example of setting up an API just to do math is certainly not the
most practical, being able to set up dynamic routes and access data via the
params hash will become incredibly useful once we start working with Active
Record models. For instance, we could set up a route that returns a specific
`Game` from the `games` table, formatted as JSON, using very similar code to
what we used above:

```rb
get '/games/:id' do
  game = Game.find(params[:id])
  game.to_json
end
```

This example won't work yet, since we don't have a `Game` class set up, but
we'll soon see how to get this code working!

## Conclusion

In this lesson, we covered a lot of the core functionality of Sinatra. We saw
how to use Sinatra's routing DSL to easily set up a server to handle requests
using different HTTP verbs and paths. We also saw how to generate both HTML and
JSON responses. Finally, we used **dynamic routes** to handle requests and
access data about a request via the **params hash**. You're well on your way
to creating your own web servers with Sinatra!

## Resources

- [Sinatra Homepage][sinatra]
- [Getting Started with Sinatra](http://sinatrarb.com/intro.html)

[sinatra]: http://sinatrarb.com/
