Pod::Spec.new do |s|
  s.name             = 'SwiftGraphVisualization'
  s.version          = '1.0.3'
  s.summary          = 'A Swift library for visualizing graphs.'

  s.description      = <<-DESC
  SwiftGraphVisualization is a Swift library designed to visualize graphs.
                       DESC

  s.homepage         = 'https://github.com/VAndrJ/SwiftGraphVisualization'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Volodymyr Andriienko' => 'vandrjios@gmail.com' }
  s.source           = { :git => 'https://github.com/VAndrJ/SwiftGraphVisualization.git', :tag => s.version.to_s }
  s.social_media_url = 'https://www.linkedin.com/in/vandrj/'

  s.ios.deployment_target = '13.0'

  s.source_files = 'SwiftGraphVisualization/Classes/**/*'

  s.frameworks = 'UIKit'

  s.swift_versions = '5.9'
end
