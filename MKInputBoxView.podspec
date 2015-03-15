#
# Be sure to run `pod lib lint MKInputBoxView.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name                = "MKInputBoxView"
  s.version             = "0.9.3"
  s.summary             = "A tiny class to replace UIAlertView."
  s.description         = "MKInputBoxView is a tiny class that lets you replace UIAlertView with a better customizable view."
  s.homepage            = "https://github.com/planetexpress69/MKInputBoxView"
  s.screenshots         = "http://teambender.de/pub/github/MKInputBoxViewLoginAndPassword.png", "http://teambender.de/pub/github/MKInputBoxViewNumber.png", "http://teambender.de/pub/github/MKInputBoxViewPlainText.png"
  s.license             = "MIT"
  s.author              = { "planetexpress69" => "martin@teambender.de" }
  s.source              = { :git => "https://github.com/planetexpress69/MKInputBoxView.git", :tag => s.version.to_s }
  s.social_media_url    = "https://twitter.com/planetexpress69"
  s.platform            = :ios, '8.0'
  s.requires_arc        = true
  s.source_files        = 'MKInputBoxView/**/*'
end
