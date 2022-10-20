source 'https://cdn.cocoapods.org'

platform :ios, '14.0'
install! 'cocoapods', :deterministic_uuids => false
use_frameworks!
inhibit_all_warnings!

workspace 'bruteForcer.xcworkspace'

def commonPods
  pod 'Alamofire'
  pod 'RxCocoa'
  pod 'RxSwift'

  pod 'SwiftyBeaver'
  pod 'Swinject'
end

abstract_target 'BruteForcerProjects' do
  target 'bruteForcer' do
    project 'bruteForcer.xcodeproj'
    commonPods
  end

  target 'bruteForcerTests' do
    commonPods
  end
end
