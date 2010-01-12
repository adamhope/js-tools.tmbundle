#!/usr/bin/env ruby

require "fileutils"

FILEPATH      = ENV['TM_FILEPATH']
SUPPORT       = ENV['TM_BUNDLE_SUPPORT']
TAB_SIZE      = ENV['TM_TAB_SIZE']
SELECTED_TEXT = ENV['TM_SELECTED_TEXT']
JSC           = "#{SUPPORT}/bin/JavaScriptCore.framework/Resources/jsc"
BEAUTIFY      = "#{SUPPORT}/lib/beautify.js"
LAUNCHER      = "#{SUPPORT}/bin/beautifier.js"

# INPUT is the content of the file, regardless of whether it's been saved
INPUT = ARGF.read

# pass the selected text options as arguments to the launcher
path    = ENV['TM_BUNDLE_SUPPORT'] +  "/jsbeautifier-tmp" + rand(1000000).to_s + ".js"
my_file = File.new(path,"w+") # create a file object
my_file.puts(INPUT)             # put the selection in it
my_file.flock(File::LOCK_UN)  # unlock the file
output = `"#{JSC}" "#{BEAUTIFY}" "#{LAUNCHER}" -- "{file: '#{path}', indent_size: #{TAB_SIZE}, space_after_anon_function: true}"`
File.delete(path)

# NOTE beutifier formates "function(){}()" as "function () {} ()" which fails JSLint should be "function () {}()"
output = output.gsub(/\}\s+\(\)/, "}()")

puts output
