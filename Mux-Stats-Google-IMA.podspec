#
# Be sure to run `pod lib lint MUXSDKImaListener.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Mux-Stats-Google-IMA'
  s.version          = '0.1.0-beta.0'
  s.summary          = 'Mux-Stats-Google-IMA is for tracking performance analytics and QoS monitoring for video with mux.com.'

  s.description      = <<-DESC
    The Mux stats Google IMA is designed to be used with Mux-Stats-AVPlayer and GoogleAds-IMA-iOS-SDK to track performance analytics and QoS monitoring for video.
                       DESC

  s.homepage         = 'https://mux.com'
  s.social_media_url = 'https://twitter.com/muxhq'
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author           = { 'Mux' => 'ios-sdk@mux.com' }
  s.source           = { :git => 'https://github.com/muxinc/mux-sdk-ima-listener.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'MUXSDKImaListener/Classes/**/*'

  s.dependency 'Mux-Stats-AVPlayer', '~> 0.1.5'
  s.dependency 'Mux-Stats-Core', '~>2.0.0'
  s.dependency 'GoogleAds-IMA-iOS-SDK', '~> 3.9'
end
