#
#  Be sure to run `pod spec lint MBMediator.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "MBMediator"
  s.version      = "0.0.2"
  s.summary      = "组件化中间层"
  s.description  = <<-DESC
                    组件化中间层实现，仿CTMediator，处理中间层方法返回值为void的问题。
                   DESC
  s.homepage     = "https://github.com/MarioBiuuuu/MBMediator"
  s.license      = "MIT"
  s.author             = { "张晓飞" => "tobe1016@163.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/MarioBiuuuu/MBMediator.git", :tag => s.version}
  s.source_files  = "MBMediator", "MBMediator/**/*.{h,m}"

end
