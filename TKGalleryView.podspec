#
# Be sure to run `pod lib lint TKGalleryView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TKGalleryView'
  s.version          = '0.1.0'
  s.summary          = 'TKGalleryView browse like Facebook App'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TKGalleryView browse like Facebook App
Tiki App avaiable on AppStore
                       DESC

  s.homepage         = 'https://github.com/ducnnguyen/TKGalleryView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'duc.nguyen@tiki.vn' => 'duc.nguyen@tiki.vn' }
  s.source           = { :git => 'https://github.com/ducnnguyen/TKGalleryView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

    s.ios.deployment_target = '8.0'

    s.source_files = 'Pod/Classes/**/*.{h,m}'
    s.resource_bundles = {
        'TKGalleryView' => ['Pod/Assets/**/*.{xcassets,xib}']
    }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
    s.dependency 'ReactiveCocoa', '~> 2.5'
    s.dependency 'TTTAttributedLabel'
    s.dependency 'HCSStarRatingView'
    s.dependency 'SDWebImage'
    s.dependency 'pop'
    s.dependency 'Masonry'
end
