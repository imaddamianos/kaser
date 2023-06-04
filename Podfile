# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'kaser' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for kaser

pod 'Firebase/Core'
pod 'Firebase/Database'
pod 'Firebase/Storage'
pod 'FirebaseUI'
pod 'SkyFloatingLabelTextField'
pod 'SCLAlertView'
pod 'iOSDropDown'
pod 'MDatePickerView'
pod 'ProgressHUD'
#pod 'ImagePicker'
pod ‘SideMenu’

  target 'kaserTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'kaserUITests' do
    # Pods for testing
  end

end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
               end
          end
   end
end
