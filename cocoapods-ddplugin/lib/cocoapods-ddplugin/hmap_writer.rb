require 'cocoapods'
require_relative 'hmap_constructor'
require_relative 'pod_xcconfig'
require_relative 'pod_target'
require_relative 'podfile_dsl'
require_relative 'pod_context_hook'

module HMap
  class HMapFileWriter
    def initialize(context)

      hmap_dir = context.sandbox_root + '/Headers/HMap'
      aggregate_targets = context.aggregate_targets
      FileUtils.rm_rf(hmap_dir) if File.exist?(hmap_dir)
      Dir.mkdir(hmap_dir)
      gen_hmapfile(aggregate_targets, hmap_dir)
    end

    def gen_hmapfile(aggregate_targets, hmap_dir)
      aggregate_targets.each do |aggregate_target|
        pods_hmap = HMap::HMapConstructor.new
        aggregate_target.pod_targets.each do |target|

          unless $skip_hmap_header_for_pods.include?(target.name)
            pods_hmap.add_hmap_with_header_mapping(target.header_mappings_by_file_accessor, target.name)
          else
            puts "- skip input hmapfile of target :#{target.name}"
            next
          end

          unless $skip_hmap_for_pods.include?(target.name)
            target_hmap = HMap::HMapConstructor.new
            dependent_target_header_search_path_setting = Array.new
            target_hmap.add_hmap_with_header_mapping(target.header_mappings_by_file_accessor, target.name)

            target.dependent_targets.each do |dependent_target|
              target_hmap.add_hmap_with_header_mapping(dependent_target.public_header_mappings_by_file_accessor, dependent_target.name)

              dependent_target.build_settings.each do |config, setting|
                dependent_target_xcconfig = setting.xcconfig
                dependent_target_header_search_paths = dependent_target_xcconfig.attributes['HEADER_SEARCH_PATHS']
                dependent_target_header_search_paths.split(' ').each do |path|
                  unless (path.include?('${PODS_ROOT}/Headers') || path.include?('$(inherited)'))
                    dependent_target_header_search_path_setting << path
                  end
                end
              end
              target.dependent_target_header_search_path_setting = dependent_target_header_search_path_setting.uniq
            end

            target_hmap_name = "#{target.name}-prebuilt.hmap"
            target_hmap_path = hmap_dir + "/#{target_hmap_name}"
            relative_hmap_path = "Headers/HMap/#{target_hmap_name}"
            if target_hmap.save_to(target_hmap_path)
              puts "- hmapfile of target :#{target.name} save to :#{target_hmap_path}".yellow
              target.reset_header_search_with_relative_hmap_path(relative_hmap_path)
            else
              $fail_generate_hmap_pods << target.name
            end
          else
            puts "- skip generate hmapfile of target :#{target.name}"
          end
        end

        pods_hmap_name = "#{aggregate_target.name}-prebuilt.hmap"
        pods_hmap_path = hmap_dir + "/#{pods_hmap_name}"
        relative_hmap_path = "Headers/HMap/#{pods_hmap_name}"
        if pods_hmap.save_to(pods_hmap_path)
          puts "- hmapfile of target :#{aggregate_target.name} save to :#{pods_hmap_path}".green
          aggregate_target.reset_header_search_with_relative_hmap_path(relative_hmap_path)
        end
      end
    end
  end
end
