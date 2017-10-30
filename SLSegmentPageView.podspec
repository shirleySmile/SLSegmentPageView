
Pod::Spec.new do |s|
  s.name             = 'SLSegmentPageView'
  s.version          = '0.1.3'
  s.summary          = ' select segment and show which one page.'

  s.description      = <<-DESC
0.1.0
add initial file with select segment and show which one page.
0.1.1
modify enum
0.1.2
modify make method


                       DESC

  s.homepage         = 'https://github.com/shirleySmile/SLSegmentPageView'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'SHAO LEI' => '276482207@qq.com' }
  s.source           = { :git => 'https://github.com/shirleySmile/SLSegmentPageView.git', :tag => s.version }
  s.ios.deployment_target = '8.0'

  s.source_files = 'SLSegmentPageView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SLSegmentPageView' => ['SLSegmentPageView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
