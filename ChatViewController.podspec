Pod::Spec.new do |s|
  s.name = 'ChatViewController'
  s.version = '0.0.1'
  s.license = 'MIT'
  s.summary = 'ChatViewController, ChatBar, ImagePicker like Slack Application.'
  s.homepage = 'https://github.com/hoangtaiki/ChatViewController'
  s.authors = { 'Hoangtaiki' => 'duchoang.vp@gmail.com' }
  s.source = { :git => 'https://github.com/hoangtaiki/ChatViewController.git', :tag => s.version }

  s.requires_arc = true
  s.platform = :ios, "10.0"

  s.source_files = 'Source/**/*.swift'
  s.resource_bundles = {'ChatViewController' => ['Source/Resources/**/*.{png,xcassets,xib}']}

  s.ios.frameworks = 'UIKit', 'Foundation'
end
