Pod::Spec.new do |s|
  s.name             = '${POD_NAME}'
  s.version          = '0.1.0'
  s.summary          = 'A short description of ${POD_NAME}.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.license          = { :type => 'All rights reserved.', :file => 'LICENSE' }
  s.author           = { '${USER_NAME}' => '${USER_EMAIL}' }
  s.source           = { :git => 'https://github.com/SalesforceFoundation/makana-repo.git', :tag => s.name.to_s + "-" + s.version.to_s }
  s.homepage = 'https://github.com/SalesforceFoundation/makana-repo/kalani/PrivatePods/${POD_NAME}'

  s.ios.deployment_target = '11.4'

  s.source_files = '${POD_NAME}/Sources/**/*'
  
  # s.resource_bundles = {
  #   '${POD_NAME}' => ['${POD_NAME}/Assets/*.png']
  # }
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'PCAPI', '~> 1.0'
end
