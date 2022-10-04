# !/usr/bin/env ruby

module HMap
  class HMapConstructor
    def initialize
      @bucket = Hash.new
    end

    # header_mapping : [Hash{FileAccessor => Hash}] Hash of file accessors by header mappings.
    def add_hmap_with_header_mapping(header_mapping, target_name = nil)
      header_mapping.each do |accessor, headers|
        headers.each do |key, paths|
          paths.each do |path|
            pn = Pathname.new(path)
            basename = pn.basename.to_s
            dirname = pn.dirname.to_s + '/'
            # construct hmap hash info
            bucket = Hash['suffix' => basename, 'prefix' => dirname]
            if $use_strict_mode == false
              @bucket[basename] = bucket
            end
            if target_name != nil
              @bucket["#{target_name}/#{basename}"] = bucket
            end
          end
        end
      end
    end

    # @path : path/to/xxx.hmap
    # @return : success
    def save_to(path)
      if path != nil && @bucket.empty? == false
        pn = Pathname(path)
        json_path = pn.dirname.to_s + '/temp.json'
        # write hmap json to file
        File.open(json_path, 'w') { |file| file << @bucket.to_json }
        # json to hmap
        success = system("hmap convert #{json_path} #{path}")
        # delete json file
        File.delete(json_path)
        success
      else
        false
      end
    end
  end
end
