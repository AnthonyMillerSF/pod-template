Pod::Spec.new do |s|
  s.name             = '${POD_NAME}_Mocks'
  s.version          = '0.1.0'
  s.ios.deployment_target = '11.4'
  s.summary          = 'A collection of mock objects for unit testing with ${POD_NAME}.'
  s.description      = <<-DESC
A collection of mock objects for unit testing with ${POD_NAME}.
                       DESC

  s.license  = { :type => 'All rights reserved.', :file => 'LICENSE' }
  s.author   = { '${USER_NAME}' => '${USER_EMAIL}' }
  s.source   = { :git => 'https://github.com/SalesforceFoundation/kalani.git',
                 :tag => s.name.to_s + "-" + s.version.to_s }
  s.homepage = 'https://github.com/SalesforceFoundation/kalani/tree/develop/PrivatePods/${POD_NAME}'

  s.static_framework = true

  s.source_files = 'TestMocks/**/*.swift'

  s.dependency '${POD_NAME}'
  s.dependency 'PCCore_Mocks'

  # s.dependency 'Swinject'
  
end
