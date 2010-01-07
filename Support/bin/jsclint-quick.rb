#!/usr/bin/env ruby

FILEPATH = ENV['TM_FILEPATH']
SUPPORT  = ENV['TM_BUNDLE_SUPPORT']
JSC      = "#{SUPPORT}/bin/JavaScriptCore.framework/Resources/jsc"
JSLINT   = "#{SUPPORT}/lib/fulljslint.js"
PREFS    = "#{SUPPORT}/conf/jslint.textmate.js"
LAUNCHER = "#{SUPPORT}/bin/jsclinter.js"

# BINARY   = `uname -a` =~ /i386/ ? "#{SUPPORT}/bin/intel/jsl" : "#{SUPPORT}/bin/ppc/jsl"

output = `"#{JSC}" "#{JSLINT}" "#{PREFS}" "#{LAUNCHER}" -- "#{FILEPATH}" "quick"`
puts output
