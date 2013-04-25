# Update apt cache
include_recipe 'apt'

# Configure the basic system
include_recipe 'station::user'

# Installing base packages
node['station']['packages']['base'].each do |pkg|
  package pkg
end

# Installing required packages
node['station']['packages']['required'].each do |pkg|
  package pkg
end

# User should be vagrant or 'aentos'
node['instance_role'] ||= 'aentos'

# Sigar
bash "Download Sigar" do
  user node['station']['user_name']
  code "sudo wget 'http://svn.hyperic.org/projects/sigar_bin/dist/SIGAR_1_6_5/lib/libsigar-amd64-linux.so' -O /usr/lib/libsigar-amd64-linux.so"
end

# Iptables
bash "Configure iptables" do
  user node['station']['user_name']
  code "sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 9080"
end

# Java
if node['station']['java']

  bash "Configure default java" do
    user node['station']['user_name']
    code "sudo add-apt-repository ppa:webupd8team/java"
    code "sudo apt-get update"
    code "sudo echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections"
  end

  node['station']['packages']['java'].each do |pkg|
    package pkg
  end

  bash "Configure default java" do
    user node['station']['user_name']
    #code "update-java-alternatives -s java-7-oracle"
  end
end

#TBD: Syslog to Papertrail

# Neo4j
bash "Download Neo4j" do
  user node['station']['user_name']
  code "sudo mkdir -p /var/lib/neo4j"
  code "sudo wget 'http://download.neo4j.org/artifact?edition=community&version=1.8.2&distribution=tarball&dlid=notread' -O /var/lib/neo4j/neo4j-1.8.2.tar.gz"
  code "sudo wget 'http://download.neo4j.org/artifact?edition=community&version=1.9.RC1&distribution=tarball&dlid=notread' -O /var/lib/neo4j/neo4j-1.9.RC1.tar.gz"
end

bash "Decompress Neo4j" do
  code "sudo tar xvfz /var/lib/neo4j/neo4j-1.8.2.tar.gz -C /var/lib/neo4j"
  code "sudo tar xvfz /var/lib/neo4j/neo4j-1.9.RC1.tar.gz -C /var/lib/neo4j"
end

bash "Remove documentation to Neo4j" do
  user node['station']['user_name']
  code "sudo rm -r /var/lib/neo4j/*/doc"
  code "find /var/lib/neo4j | egrep 'groovy|udc' | sudo xargs rm -v"
end

bash "Configure DB storage" do
  user node['station']['user_name']
  code "sudo mkdir -p /srv/storage/databases; sudo chown 1000:1000 /srv/storage/databases"
end

#TBD: Start the server
