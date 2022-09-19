require 'cocoapods-my-debug/command/debug'

Pod::HooksManager.register('cocoapods-my-debug', :pre_install) do |installer_context|

    Pod::UI.puts "\n"
    Pod::UI.puts "Hook  Pod Install"
    Pod::UI.puts "\n"

end