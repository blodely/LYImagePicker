#
# Be sure to run `pod lib lint LYImagePicker.podspec' to ensure this
# Created By Luo Yu (indie.luo@gmail.com)
# Wednesday, June 14, 2017
#

Pod::Spec.new do |s|
	s.name             = 'LYImagePicker'
	s.version          = '1.13.0'
	s.summary          = 'LYImagePicker.'

	s.description      = <<-DESC
A Custom Image Picker.
1.0.0: iOS10+.
1.13.0: iOS11+.
					   DESC

	s.homepage         = 'https://github.com/blodely/LYImagePicker'

	s.license          = { :type => 'GPL-2.0', :file => 'LICENSE' }
	s.author           = { 'Luo Yu' => 'indie.luo@gmail.com' }
	s.source           = { :git => 'https://github.com/blodely/LYImagePicker.git', :tag => s.version.to_s }

	s.social_media_url = 'https://weibo.com/blodely'

	s.ios.deployment_target = '11.0'

	s.source_files = 'LYImagePicker/Classes/LYISelectorGrid/*', 'LYImagePicker/Classes/LYIVideoSlider/*', 'LYImagePicker/Classes/LYIVideoRange/*', 'LYImagePicker/Classes/LYICamera/*', 'LYImagePicker/Classes/LYIDetect/*', 'LYImagePicker/Classes/toolkit/*', 'LYImagePicker/Classes/*'

	s.resource_bundles = {
		'LYImagePicker' => ['LYImagePicker/Assets/*.png']
	}

	# s.public_header_files = 'Pod/Classes/**/*.h'
	# s.frameworks = 'UIKit', 'MapKit'
	# s.dependency 'AFNetworking', '~> 2.3'

	s.ios.frameworks = 'UIKit', 'Photos', 'AVFoundation', 'ImageIO', 'MobileCoreServices'
	
	s.ios.dependency 'LYCategory', '~> 1.13'
	s.ios.dependency 'LYCore', '~> 1.13'
	s.ios.dependency 'GPUImage'

end
