Pod::Spec.new do |s|
  s.name         = "WSFoundation"
  s.version      = "0.0.2"
  s.summary      = "A set of useful tools for common iOS patterns."
  s.homepage     = "http://github.com/rayh/ws-foundation"

  s.license      = 'MIT'
  s.author       = { "Ray Hilton" => "ray@wirestorm.net" }
  s.source       = { :git => "https://github.com/rayh/ws-foundation.git", :tag => "#{s.version}" }
  s.platform     = :ios, '5.0'
  s.ios.deployment_target = '5.0'

  s.source_files = '**/*.{h,m}'

  # s.framework  = 'SomeFramework'
  # s.frameworks = 'SomeFramework', 'AnotherFramework'

  # s.library   = 'iconv'
  # s.libraries = 'iconv', 'xml2'

  s.requires_arc = true

  # s.dependency 'JSONKit', '~> 1.4'
end
