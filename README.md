## Vagrant pre-configured boxes.

Here you find a list of some pre-configured vagrant boxes. They can be
used for fast development when you just want a machine with certain
servers on it running and default config. 

Since these are not [base boxes](http://vagrantbox.es/) or
[packaged](http://vagrantup.com/docs/boxes.html) ones, you can change the
`Vagrantfile` and `puppet` manifests to suit your needs before even starting
the machine or installing any software.

## Boxes

* **hbase-single**: single instance hbase running.

## How to use

Make sure that you have `vagrant` installed and the base box added,
check [Vagrant](http://vagrantup.com/) website for more details.
Usually is simple as:

	$ gem install vagrant
	$ vagrant box add base http://files.vagrantup.com/lucid32.box

Clone this repository, update puppet modules, pick one machine that you want to
start and run `vagrant up`. Vagrant + Puppet should take care of installing and
configuring whatever is necessary for the server to run. Example:

	$ git clone https://github.com/mavcunha/vagrant-preconfig-boxes.git vagrant-preconfig-boxes
	$ cd vagrant-preconfig-boxes
	$ git submodule update --init 
	$ cd hbase-single
	$ vagrant up

Puppet will install all binaries for the server (if not in the base
box already) so it can take some minutes depending on your internet
connection.
