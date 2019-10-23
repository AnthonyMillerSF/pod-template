Pod::Spec.new do |s|
  s.name             = '${POD_NAME}'
  s.version          = '0.1.0'
  s.ios.deployment_target = '11.4'
  s.summary          = 'A short description of ${POD_NAME}.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.license  = { :type => 'All rights reserved.', :file => 'LICENSE' }
  s.author   = { '${USER_NAME}' => '${USER_EMAIL}' }
  s.source   = { :git => 'https://github.com/SalesforceFoundation/kalani.git',
                 :tag => s.name.to_s + "-" + s.version.to_s }
  s.homepage = 'https://github.com/SalesforceFoundation/kalani/tree/develop/PrivatePods/${POD_NAME}'

  s.static_framework = true

  s.source_files = '${POD_NAME}/Sources/**/*.swift'
  
  s.dependency 'PCCore'

  # s.resource_bundles = {
  #   '${POD_NAME}' => [
  #     '${POD_NAME}/Assets/**/*.*',
  #     '${POD_NAME}/Sources/**/*.{xib,storyboard}'
  #   ]
  # }
  # s.frameworks = 'UIKit'

  s.test_spec 'Tests' do |ts|
    ts.source_files = 'Tests/**/*.swift'

    ts.dependency 'PCTestMocks'
    ${INCLUDED_TEST_DEPS}
  end

  ${EXAMPLE_APP_SPEC}
end
