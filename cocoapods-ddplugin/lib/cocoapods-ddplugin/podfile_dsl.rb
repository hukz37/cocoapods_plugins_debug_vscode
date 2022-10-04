# !/usr/bin/env ruby

$skip_hmap_for_pods = []
$skip_hmap_header_for_pods = []
$use_strict_mode = false

module Pod
  class Podfile
    module DSL
      def skip_hmap_for_pods(pods)
        if pods != nil && pods.size() > 0
          $skip_hmap_for_pods.concat(pods)
        end
      end

      def skip_hmap_header_for_pods(pods)
        if pods != nil && pods.size() > 0
          $skip_hmap_header_for_pods.concat(pods)
        end
      end

      # if use strict mode, main project can only use `#import <PodA/HeaderA.h>`
      # `#import <HeaderA.h>` will get 'file not found' error
      def use_strict_mode!
        $use_strict_mode = true
      end
    end
  end
end