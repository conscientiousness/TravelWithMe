platform :ios,'8.0'

use_frameworks!

target 'TravelWithMe' do

  pod "ParallaxBlur"
  pod "FBSDKCoreKit"
  pod "FBSDKLoginKit"
  pod "FBSDKShareKit"
  pod "SDWebImage"
  pod "MBProgressHUD"
  pod "ParseUI"
  pod "ParseFacebookUtilsV4", '~>1.8.5'
  pod "JDFPeekaboo"
  pod "SSBouncyButton"
  pod "MJRefresh"
  pod "SCLAlertView-Objective-C"
  pod "VBFPopFlatButton"
  pod "DateTools"
  pod "JTSImageViewController"
  pod "TextFieldEffects"

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end

