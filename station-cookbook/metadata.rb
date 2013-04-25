name              "station"
maintainer        "Alberto Hernandez Mateos"
maintainer_email  "alberto.hernandez@aentos.es"
license           "Apache 2.0"
description       "Prepare a station machine of graphenedb project"
version           "1.1.8"


%w{ debian ubuntu }.each do |os|
  supports os
end

%w{ apt sudo }.each do |os|
  depends os
end
