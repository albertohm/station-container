# This gem is required for the user resource to use passwords
chef_gem 'ruby-shadow'

unless node.has_key? 'instance_role' and node['instance_role'] == 'vagrant'
  # Create the aentos user
  user node['user_name'] do
    home     node['user_home']
    shell    node['station']['shell']
    password node['station']['password']
    supports :manage_home => true
  end
end

# Add the aentos user to the sudoers with NOPASSWD
sudo node['user_name'] do
  user node['user_name']
  commands [ "ALL" ]
  nopasswd true
end

# Add a custom PS1 var to a profile script (/etc/profile.d/*.sh)
file "/etc/profile.d/ps1.sh" do
  content node['station']['ps1']
end

# Set the hostname
file "/etc/hostname" do
  content node['station']['hostname']
end
