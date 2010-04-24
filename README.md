# MongoBlog #

This is an aspiring project intended to be a blogging platform similar to [scanty](http://github.com/adamwiggins/scanty) or 
[Typo](http://github.com/fdv/typo). The intent is primarily to provide a simple platform built upon 
[Sinatra](http://www.sinatrarb.com/), [Padrino](http://www.padrinorb.com/), and [Mongoid](http://mongoid.org/)
allowing the easy management and deployment of a relatively full-featured blog.

## Note ##

Right now this is not much more than an experiment! So please use this at your own risk
until this message is removed. Demo is at [MongoBlog Demo](http://mongo_blog.lipsiasoft.biz)

## Installation ##

Right now the best way to install this is to checkout from the git repository:

    git clone git://github.com/nesquena/mongo_blog.git
    cd mongo_blog
    sudo bundle install

This will setup the blog and all necessary gem dependencies. The only step now is to setup
passenger, apache, etc to properly route requests to the application. In the future, I plan
to make this process as easy as reasonably possible.

## Features ##

MongoBlog will have all the essential features expected of a blog:

* Creating entries
* Multiple author accounts
* Basic entry tagging
* Easily skinnable to meet your needs
* Archiving old posts
* Automatic RSS and Atom generation
* Markdown syntax support
* Code syntax highlighting
* Comments via Disqus
* Web framework = Padrino
* ORM = Mongoid (MongoDB)

## Comments ##

There are no comments by default. If you wish to activate comments, create an account and a 
website on Disqus (disqus.com) and enter the website shortname as the :disqus_shortname value 
in the Blog config struct.