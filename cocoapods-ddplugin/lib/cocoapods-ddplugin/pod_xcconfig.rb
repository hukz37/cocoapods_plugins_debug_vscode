# !/usr/bin/env ruby

module Xcodeproj
  class Config
    def remove_attr_with_key(key)
      if key != nil
        @attributes.delete(key)
      end
    end

    def remove_header_search_path
      header_search_paths = @attributes['HEADER_SEARCH_PATHS']
      if header_search_paths
        new_paths = Array.new
        header_search_paths.split(' ').each do |path|
          unless (path.include?('${PODS_ROOT}/Headers/Public') || path.include?('${PODS_ROOT}/Headers/Private') || path.include?('$(inherited)'))
            new_paths << path
          end
        end
        if new_paths.size > 0
          @attributes['HEADER_SEARCH_PATHS'] = new_paths.join(' ')
        else
          remove_attr_with_key('HEADER_SEARCH_PATHS')
        end
      end
      remove_system_options_in_other_cflags
    end

    def remove_system_options_in_other_cflags
      flags = @attributes['OTHER_CFLAGS']
      if flags
        new_flags = ''
        skip = false
        flags.split(' ').each do |substr|
          if skip
            skip = false
            next
          end
          if substr == '-isystem'
            skip = true
            next
          end
          if new_flags.length > 0
            new_flags += ' '
          end
          new_flags += substr
        end
        if new_flags.length > 0
          @attributes['OTHER_CFLAGS'] = new_flags
        else
          remove_attr_with_key('OTHER_CFLAGS')
        end
      end
    end

    def reset_header_search_with_relative_hmap_path(hmap_path, dependent_header_search_path_setting = nil)
      remove_header_search_path
      # add build flags
      new_paths = Array.new
      new_paths << "${PODS_ROOT}/#{hmap_path}"
      header_search_paths = @attributes['HEADER_SEARCH_PATHS']
      if header_search_paths
        new_paths.concat(header_search_paths.split(' '))
      end
      new_paths.concat(dependent_header_search_path_setting) if dependent_header_search_path_setting
      @attributes['HEADER_SEARCH_PATHS'] = new_paths.join(' ')
    end

    def addition_aggregate_hmapfile_to_pod_target(hmap_path)
      new_paths = Array.new
      header_search_paths = @attributes['HEADER_SEARCH_PATHS']
      if header_search_paths
        new_paths.concat(header_search_paths.split(' '))
      end
      new_paths << "${PODS_ROOT}/#{hmap_path}"
      @attributes['HEADER_SEARCH_PATHS'] = new_paths.join(' ')
    end

    def set_use_hmap(use_hmap = false)
      @attributes['USE_HEADERMAP'] = (use_hmap ? 'YES' : 'NO')
    end
  end
end
