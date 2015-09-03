Math Notes

About
===
This is a collection of notes from my math studies.

One of the best ways to learn something is to pretend you are teaching
it to someone else.  That is the purpose of these notes.

I wanted to also see if I could use professional typesetting so
I am using the [MathJax](https://www.mathjax.org/) library.

Building
===
Make sure `node` is installed on your system.

    npm install -g coffee-script gulp

    npm install

    cp config-example.yml config.yml

    gulp

It should watch the src folder for changes and automatically update the build folder.

You can copy the build folder to a server somewhere to view the output.  They are all static files.

When you run `gulp` by default it will start up a server on the port specified in `config.yml`.
