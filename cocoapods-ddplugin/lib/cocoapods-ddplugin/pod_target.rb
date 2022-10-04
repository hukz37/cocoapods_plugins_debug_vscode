# !/usr/bin/env ruby

require_relative 'pod_xcconfig'
require_relative 'podfile_dsl'

$fail_generate_hmap_pods = []

module Pod
  class PodTarget
    attr_accessor :dependent_target_header_search_path_setting

    def reset_header_search_with_relative_hmap_path(hmap_path)
      if build_settings.instance_of?(Hash)
        build_settings.each do |config_name, setting|
          config_file = setting.xcconfig
          config_file.reset_header_search_with_relative_hmap_path(hmap_path, @dependent_target_header_search_path_setting)
          config_file.set_use_hmap(false)
          config_path = xcconfig_path(config_name)
          config_file.save_as(config_path)
        end
      elsif build_settings.instance_of?(BuildSettings::PodTargetSettings)
        config_file = build_settings.xcconfig
        config_file.reset_header_search_with_relative_hmap_path(hmap_path, @dependent_target_header_search_path_setting)
        config_file.set_use_hmap(false)
        config_path = xcconfig_path
        config_file.save_as(config_path)
      else
        puts 'Unknown build settings'.red
      end
    end

    def addition_aggregate_hmapfile_to_pod_target(hmap_path)
      if build_settings.instance_of?(Hash)
        build_settings.each do |name, setting|
          config_file = setting.xcconfig
          config_file.addition_aggregate_hmapfile_to_pod_target(hmap_path)
          config_file.save_as(xcconfig_path(name))
        end
      elsif build_settings.instance_of?(BuildSettings::PodTargetSettings)
        config_file = build_settings.xcconfig
        config_file.addition_aggregate_hmapfile_to_pod_target(hmap_path)
        config_file.save_as(xcconfig_path)
      else
        puts 'Unknown build settings'.red
      end
    end

  end

  class AggregateTarget
    def reset_header_search_with_relative_hmap_path(hmap_path)
      xcconfigs.each do |config_name, config_file|
        config_file.reset_header_search_with_relative_hmap_path(hmap_path)
        config_path = xcconfig_path(config_name)
        config_file.save_as(config_path)
      end

      pod_targets.each do |target|
        unless ($skip_hmap_for_pods.include?(target.name) || $fail_generate_hmap_pods.include?(target.name))
          target.addition_aggregate_hmapfile_to_pod_target(hmap_path)
        end
      end
    end
  end
end
