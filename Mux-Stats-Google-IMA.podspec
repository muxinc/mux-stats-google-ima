#
# Be sure to run `pod lib lint MUXSDKImaListener.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Mux-Stats-Google-IMA'
  s.version          = '0.6.0'
  s.summary          = 'Mux-Stats-Google-IMA is for tracking performance analytics and QoS monitoring for video with mux.com.'

  s.description      = <<-DESC
    The Mux Stats Google IMA is designed to be used with Mux-Stats-AVPlayer and GoogleAds-IMA-iOS-SDK to track performance analytics and QoS monitoring for video.
                       DESC

  s.homepage         = 'https://mux.com'
  s.social_media_url = 'https://twitter.com/muxhq'
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author           = { 'Mux' => 'ios-sdk@mux.com' }
  s.source           = { :git => 'https://github.com/muxinc/mux-stats-google-ima.git', :tag => "v#{s.version}" }

  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'


  s.ios.dependency 'Mux-Stats-AVPlayer', '~> 2.0'
  s.ios.dependency 'GoogleAds-IMA-iOS-SDK', '~> 3.13'
  s.ios.source_files = 'MUXSDKImaListener/Classes/**/*'

  s.tvos.dependency 'Mux-Stats-AVPlayer', '~> 2.0'
  s.tvos.dependency 'GoogleAds-IMA-tvOS-SDK', '~> 4.3'
  s.tvos.source_files = 'MUXSDKImaListener/Classes/**/*'


  s.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',
    'EXCLUDED_ARCHS[sdk=appletvsimulator*]' => 'arm64'
  }
  s.user_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',
    'EXCLUDED_ARCHS[sdk=appletvsimulator*]' => 'arm64'
  }
end
