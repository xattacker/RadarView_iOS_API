Pod::Spec.new do |s|
  s.name = 'RadarView_iOS'
  s.version = '1.0.1'
  s.license = 'BSD'
  s.summary = 'RadarView iOS Swift API'
  s.homepage = 'https://github.com/xattacker/RadarView_iOS_API'
  s.authors = { 'Xattacker' => 'amigo.xattacker@gmail.com' }
  s.source = { :git => 'https://github.com/xattacker/RadarView_iOS_API.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'

  s.requires_arc = true
  s.source_files = 'RadarView/Sources/*.swift'
end
