#
# Be sure to run `pod lib lint SwiftLocale.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftLocale'
  s.version          = '1.0.0'
  s.summary          = 'A short description of SwiftLocale.'

  s.description      = <<-DESC
SwiftLocale for manage external localization Json File instead of bundle string files.
                       DESC

  s.homepage         = 'https://github.com/keyfun/SwiftLocale'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'KeyFun' => 'keyfun.hk@gmail.com' }
  s.source           = { :git => 'https://github.com/keyfun/SwiftLocale.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'SwiftLocale/Classes/**/*'

end
