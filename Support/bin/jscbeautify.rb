#!/usr/bin/env ruby

require "fileutils"

FILEPATH      = ENV['TM_FILEPATH']
SUPPORT       = ENV['TM_BUNDLE_SUPPORT']
TAB_SIZE      = ENV['TM_TAB_SIZE']
SELECTED_TEXT = ENV['TM_SELECTED_TEXT']
JSC           = "#{SUPPORT}/bin/JavaScriptCore.framework/Resources/jsc"
BEAUTIFY      = "#{SUPPORT}/lib/beautify.js"
LAUNCHER      = "#{SUPPORT}/bin/beautifier.js"

# BINARY   = `uname -a` =~ /i386/ ? "#{SUPPORT}/bin/intel/jsl" : "#{SUPPORT}/bin/ppc/jsl"

if (SELECTED_TEXT)
    # pass the selected text options as arguments to the launcher
    sel     = "#{SELECTED_TEXT}"
    path    = ENV['TM_BUNDLE_SUPPORT'] +  "/jsc-tmp" + rand(1000000).to_s + ".js"
    my_file = File.new(path,"w+") # create a file object
    my_file.puts(sel)             # put the selection in it
    my_file.flock(File::LOCK_UN)  # unlock the file
    output = `"#{JSC}" "#{BEAUTIFY}" "#{LAUNCHER}" -- "{file: '#{path}', indent_size: #{TAB_SIZE}, space_after_anon_function: true}"`
    File.delete(path)
else
    # pass the selected file and '-f' param as an argument to the launcher
    output = `"#{JSC}" "#{BEAUTIFY}" "#{LAUNCHER}" -- "{file: '#{FILEPATH}', indent_size: #{TAB_SIZE}, space_after_anon_function: true}"`
end

# NOTE beutifier formates "function(){}()" as "function () {} ()" which fails JSLint should be "function () {}()"
output = output.gsub(/\}\s+\(\)/, "}()")

puts output
