# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def shared_pods
  pod 'FacebookLogin'
  pod 'GoogleSignIn'
  pod 'Firebase/Auth'
end

target 'ToDoApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  shared_pods

  target 'ToDoAppTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ToDoAppUITests' do
    shared_pods
  end

end

