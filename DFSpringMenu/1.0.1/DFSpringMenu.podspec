Pod::Spec.new do |spec|
  spec.name         = "DFSpringMenu"
  spec.version      = "1.0.1"
  spec.summary      = "自用弹簧菜单"
  spec.description  = <<-DESC
自用弹簧菜单自用弹簧菜单自用弹簧菜单自用弹簧菜单自用弹簧菜单自用弹簧菜单自用弹簧菜单自用弹簧菜单自用弹簧菜单自用弹簧菜单
                   DESC

  spec.homepage     = "https://github.com/yukifeng/DFSpringMenu"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  spec.license      = "MIT"
  spec.author             = { "雪乃我的嫁" => "413678315@qq.com" }

  spec.platform     = :ios, "8.0"

  spec.source       = { :git => "https://github.com/yukifeng/DFSpringMenu.git", :tag => "#{spec.version}" }

  spec.source_files  = "Classes/*.{h,m}"
  spec.exclude_files = "demo/"

  # spec.public_header_files = "Classes/**/*.h"

  spec.framework  = "UIKit"
  spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end
