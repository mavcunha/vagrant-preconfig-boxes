## Vagrant pre-configured boxes.

Here you find a list of some pre-configured vagrant boxes. They can be
used for fast development when you just want a machine with certain
servers on it running and default config. 

Since these are not [base boxes](http://vagrantbox.es/) or
[packaged](http://vagrantup.com/docs/boxes.html) ones, you can change the
`Vagrantfile` and `puppet` manifests to suit your needs before even starting
the machine or installing any software.

## Boxes

Check the `boxes` directory for more information.

## Setting it up

A `bundle install` should set up all gems needed.

## How to use

Make sure that you have `vagrant` installed (it should be bundler step above)
and the base box added, check [Vagrant](http://vagrantup.com/) website for more
details.Usually is simple as:

	$ vagrant box add base http://files.vagrantup.com/lucid32.box

I've setup it some rake tasks to help, here a brief description.

	$ rake boxes

It should a list of the boxes available, then what you need is to install the
puppet (or chef in the future) dependencies for a certain box. Let's say you
want to set up a box called `MYBOX`, you can use:

	$ rake MYBOX.setup

This should setup the box, `vagrant up` (on the box directory) should finish it
and install other dependencies for that specific box.
