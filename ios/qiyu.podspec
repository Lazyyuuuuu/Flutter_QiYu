
Pod::Spec.new do |s|
  s.name             = 'qiyu'
  s.version          = '0.0.1'
  s.summary          = 'qiyu plugin for flutter.'
  s.description      = <<-DESC
qiyu SDK plugin for flutter.
                       DESC
  s.homepage         = 'https://github.com/Lazyyuuuuu/Flutter_QiYu'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Lazyyuuuuu' => 'Lazyyuuuuu@163.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'QIYU_iOS_SDK',    '~> 4.3.0'

  s.ios.deployment_target = '8.0'
end

