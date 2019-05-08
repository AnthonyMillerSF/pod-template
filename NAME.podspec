Pod::Spec.new do |s|
  s.name             = '${POD_NAME}'
  s.version          = '0.1.0'
  s.summary          = 'A short description of ${POD_NAME}.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.license          = { :type => 'All rights reserved.', :file => 'LICENSE' }
  s.author           = { '${USER_NAME}' => '${USER_EMAIL}' }
  s.source           = { :git => 'https://github.com/SalesforceFoundation/${POD_NAME}.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.4'

  s.source_files = '${POD_NAME}/Sources/**/*'
  
  # s.resource_bundles = {
  #   '${POD_NAME}' => ['${POD_NAME}/Assets/*.png']
  # }
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'PCAPI', '~> 1.0'
end
