#!/bin/bash
function print_out {
  echo "--------------------------------------------------"
  echo ""
  echo "$1"
  echo ""
  echo "--------------------------------------------------"
}

echo "Welcome to odoo-11 installer for ubuntu 16.04"
echo "Use only for dev, never for production"
echo "Take a cup of cofee while odoo is installing"

print_out "Configure locale"
sudo locale-gen > /dev/null
sudo sh -c "echo 'LANG=en_US.UTF-8\nLC_ALL=en_US.UTF-8' > /etc/default/locale"
sudo sh -c 'echo "LC_ALL=en_US.UTF-8" > /etc/environment'

print_out "Update apt-get db"
sudo apt-get update -y > /dev/null


print_out "Install git and vim"
sudo apt-get install git vim  -y > /dev/null

print_out "Install odoo dev dependencies (it may take a long time)"
sudo apt-get install python3.5 python3-ldap3 python3.5-dev libldap2-dev libsasl2-dev virtualenv postgresql-server-dev-9.5 python3-pip unoconv subversion -y > /dev/null

print_out "Install postgresql"
sudo apt-get install postgresql -y > /dev/null

print_out "Install npm and node"
sudo apt-get install npm nodejs -y > /dev/null


print_out "Configure npm and node"
sudo npm install -g less less-plugin-clean-css -y > /dev/null
sudo ln -s /usr/bin/nodejs /usr/bin/node > /dev/null


print_out "Download and install wkhtmltox"
cd /tmp
wget -q https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz > /dev/null
sudo tar -xvf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz > /dev/null
sudo mv wkhtmltox/bin/* /usr/local/bin/
rm -fr wkhtmltox-0.12.4_linux-generic-amd64.tar.xz > /dev/null


print_out "Install py3o.template"
sudo -H pip3 install py3o.template==0.9.12 > /dev/null

print_out "Download we tested this with revision 1271. When genshi 0.8 is released we can officially say we support Python3 out of the box."
print_out "Reference install: https://bitbucket.org/faide/py3o.template"
svn checkout https://svn.edgewall.org/repos/genshi/trunk genshi_trunk
cd genshi_trunk
sudo python3 setup.py build
sudo python3 setup.py install

print_out "Download odoo from github"
git clone --depth=1 --branch=11.0 https://github.com/odoo/odoo.git ~/odoo-dev/odoo > /dev/null

print_out "Install pip3 dependencies for odoo (it may take a log time)"
sudo -H pip3 install -r ~/odoo-dev/odoo/requirements.txt > /dev/null

print_out "Install lint tool for odoo"
sudo -H pip3 install --upgrade --pre pylint-odoo > /dev/null

print_out "Create dbuser (vagrant)"
sudo su - postgres -c "createuser -s $(whoami)" > /dev/null

print_out "Create db (odev11)"
createdb odev11 > /dev/null

print_out "Create user for pgadmin (admin:admin)"
sudo su - postgres -c "createuser -s admin" > /dev/null
sudo -u postgres psql -c "ALTER USER admin WITH PASSWORD 'admin';" > /dev/null

print_out "Configure postgresql to listen in all interfaces"
sudo sed -i "s/^#listen_addresses.*/listen_addresses = '*'/" /etc/postgresql/9.5/main/postgresql.conf
sudo sh -c 'echo "host  all   all   all     password" >> /etc/postgresql/9.5/main/pg_hba.conf'
sudo service postgresql restart
print_out "End of installation"

echo "Login into the VM 'vagrant ssh'"
echo "To start odoo type '~/odoo-dev/odoo/odoo.py -d odev11'"
echo "Open your browser and go to http://localhost:8069 (admin:admin)"
echo "Enjoy it !"
