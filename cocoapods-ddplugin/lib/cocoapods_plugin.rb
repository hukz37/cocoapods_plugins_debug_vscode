# !/usr/bin/env ruby
require 'cocoapods-ddplugin/hmap_writer'
require 'cocoapods-ddplugin/pod_context_hook'

module CocoapodsDdplugin
  Pod::HooksManager.register('cocoapods-ddplugin', :post_install) do |context|
    puts '进入了自定义hook'
    HMap::HMapFileWriter.new(context)
  end
end
