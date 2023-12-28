source 'https://cdn.cocoapods.org/'


platform :ios, :deployment_target => "7.0"

target "HTextInput" do
	pod "HTestVC"
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end
