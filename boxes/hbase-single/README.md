### HBase single

I made this box for a couple tests with HBase, it installs Hadoop and HBase and
starts HBase. No other configuration is done, meaning this is just for playing
with HBase. 

### Puppet will fail installing HBase

Short version:

You should run `vagrant provision` in order to trigger puppet
again and it will them install the hadoop & hbase packages.

Long version:

Cloudera packages for hbase and hadoop have a problem, they need `JAVA_HOME`
environment variable to be set otherwise the installation fail. That's a bad
design of the installation packages. Puppet has not a easy way to add an ENV
variable during package stage and I had no time to implement a workaround (which
I find good). 

The first time puppet will create the profile file with the environment variable
but that will not be available puppet, when you issue `vagrant provision`
(forcing to run puppet again) the environment will be already set up and them
the installation will work.
