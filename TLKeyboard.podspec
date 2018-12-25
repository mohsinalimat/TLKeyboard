#
# Be sure to run `pod lib lint TLKeyboard.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TLKeyboard'
  s.version          = '0.1.0'
  s.summary          = '常用的UI组件(仿微信输入框、表情键盘、功能菜单、订阅号/公众号菜单、+号菜单)'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
            '常用 UI 组件库(addMenu、、、)'
                       DESC

  s.homepage         = 'https://github.com/ylxieg/TLKeyboard'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xieyingliang' => 'ylxieg@isoftstone.com' }
  s.source           = { :git => 'https://github.com/ylxieg/TLKeyboard.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'TLKeyboard/TLComponentsKit/*'

# 子库分层模板
  s.subspec 'TLAddMenuView' do |m|
      m.source_files = 'TLKeyboard/TLComponentsKit/TLAddMenuView/*'
  end

  s.subspec 'TLPopoverView' do |m|
      m.source_files = 'TLKeyboard/TLComponentsKit/TLPopoverView/*'
  end

  s.subspec 'TLChatBar' do |m|
      m.source_files = 'TLKeyboard/TLComponentsKit/TLChatBar/*'
      m.dependency 'TLKeyboard/TLKeyborads'
      m.dependency 'TLKeyboard/TLKit/TLCategories'
  end

  s.subspec 'TLServiceBar' do |m|
      m.source_files = 'TLKeyboard/TLComponentsKit/TLServiceBar/*'
    m.resource = 'TLKeyboard/TLComponentsKit/TLServiceBar/TLServiceBar.bundle'
  end

  s.subspec 'TLKeyborads' do |m|
      m.source_files = 'TLKeyboard/TLComponentsKit/TLKeyborads/**/*'
      m.dependency 'TLKeyboard/TLKit'
  end

  s.subspec 'TLKit' do |m|
      m.source_files = 'TLKeyboard/TLComponentsKit/TLKit/*'
      
      m.subspec 'TLCategories' do |m|
          m.source_files = 'TLKeyboard/TLComponentsKit/TLKit/TLCategories/*'
          
          m.subspec 'Foundation' do |m|
              m.source_files = 'TLKeyboard/TLComponentsKit/TLKit/TLCategories/Foundation/**/*'
          end
          
          m.subspec 'UIKit' do |m|
              m.source_files = 'TLKeyboard/TLComponentsKit/TLKit/TLCategories/UIKit/**/*'
              m.dependency 'TLKeyboard/TLKit/TLCategories/Foundation'
          end
      end
      
      m.subspec 'TLFunctional' do |m|
          m.source_files = 'TLKeyboard/TLComponentsKit/TLKit/TLFunctional/**/*'
          m.dependency 'TLKeyboard/TLKit/TLShortcut'
          m.dependency 'TLKeyboard/TLKit/TLCategories/UIKit'
      end
      
      m.subspec 'TLShortcut' do |m|
          m.source_files = 'TLKeyboard/TLComponentsKit/TLKit/TLShortcut/**/*'
      end
  end
  
  # s.resource_bundles = {
  #   'TLKeyboard' => ['TLKeyboard/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
    s.dependency 'Masonry', '~> 1.1.0'
end
