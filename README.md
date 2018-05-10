# odoo-vagrant

Vagrant Setup for Odoo 11.0 on Ubuntu 16.04

Dependencies
------------

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://www.vagrantup.com)

Setup
-----

* Download and install Virtual Box

* Download and install Vagrant

* Clone this repo

```
git clone http://github.com/dperaltab/odoo-vagrant.git
```

* Start virtual machine

```
cd odoo-vagrant
vagrant up
```

* Login in the virtual machine, and start odoo


```
vagrant ssh
./odoo-dev/odoo/odoo-bin -d odev11
```

* Open your browser and go http://localhost:8069 (admin:admin)

Shared folders
--------------
src/my_addons is mapped to /home/vagrant/my_addons, you can write your modules in this directory


pgAdmin 
-------
If you want manage the postgresql server from your desktop, you only have to connect to localhost, username and password is 'admin'

Contributing
------------

1. Fork it
1. Create your feature branch (`$ git checkout -b my-new-feature`)
1. Commit your changes (`$ git commit -am 'Add some feature'`)
1. Push to the branch (`$ git push origin my-new-feature`)
1. Create new Pull Request
