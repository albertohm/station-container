# User info
if node.has_key? 'instance_role' and node['instance_role'] == 'vagrant'
  default['station']['user'] = 'vagrant'
else
  default['station']['user'] = 'aentos'
  # NOTE: The password hash was created with:
  # openssl passwd -1 "aentos"
  default['station']['password'] = '$1$q0ic4MNE$T55nMWfHyZfPeuz2dMoKY1'
  default['station']['shell'] = '/bin/bash'
end

# Set some handy vars
default['user_name'] = node['station']['user']
default['user_home'] = "/home/#{node['user_name']}"
default['user_env'] = {
  'USER' => node['user_name'],
  'HOME' => node['user_home']
}

# include these recipes?
default['station']['java'] = true

# Dependencies
default['station']['packages']['base'] = %w{
  vim screen tmux git bash-completion python-software-properties
}
default['station']['packages']['required'] = %w{
 cpulimit mdadm
}
default['station']['packages']['java'] = %w{
  oracle-java7-installer oracle-java6-installer
}

# Shell stuff
default['station']['ps1'] = %q{PS1='\[\e[36m\]\u@\h \[\e[32m\][$rvm_env_string] \[\e[35m\]($(git symbolic-ref HEAD 2> /dev/null | xargs -r basename))\[\e[36m\] \w\$\[\e[m\] '}

# Hostname
default['station']['hostname'] = "sb01.stations.graphenedb.com"
