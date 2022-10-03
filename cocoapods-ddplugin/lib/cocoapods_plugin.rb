# !/usr/bin/env ruby


module DDPluginHeaderMap
  Pod::HooksManager.register('cocoapods-ddplugin', :post_install) do |post_context|
    puts '进入了自定义hook'
  end
end
