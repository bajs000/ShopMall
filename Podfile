# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'ShopMall' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!

  pod 'SVProgressHUD'
  pod 'Masonry'
  pod 'SDWebImage'
  pod 'AFNetworking'
  pod 'SnapKit'
  pod 'MJRefresh' 
  pod 'EVNCustomSearchBar', '~> 0.1.0'
  # U-Share SDK UI模块（分享面板，建议添加）
  pod 'UMengUShare/UI'
  # 集成微信(完整版14.4M)
  pod 'UMengUShare/Social/WeChat'
  # 集成QQ/QZone/TIM(完整版7.6M)
  pod 'UMengUShare/Social/QQ'
  # 加入IDFA获取
  pod 'UMengUShare/Plugin/IDFA'

  target 'ShopMallTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ShopMallUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
