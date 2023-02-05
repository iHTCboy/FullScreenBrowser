target "FullScreenBrowser" do

platform :ios, '8.0'

pod 'AFNetworking', '~>3.0'
pod 'SDWebImage', '~>3.7'

end

post_install do | installer |
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
    end
end
