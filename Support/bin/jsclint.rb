#!/usr/bin/env ruby

FILEPATH = ENV['TM_FILEPATH']
SUPPORT  = ENV['TM_BUNDLE_SUPPORT']
JSC      = "#{SUPPORT}/bin/JavaScriptCore.framework/Resources/jsc"
JSLINT   = "#{SUPPORT}/lib/fulljslint.js"
PREFS    = "#{SUPPORT}/conf/jslint.textmate.js"
LAUNCHER = "#{SUPPORT}/bin/jsclinter.js"

# INPUT is the content of the file, regardless of whether it's been saved
INPUT = ARGF.read

# pass the selected text options as arguments to the launcher
path    = ENV['TM_BUNDLE_SUPPORT'] +  "/src-tmp" + rand(1000000).to_s + ".js"
my_file = File.new(path,"w+") # create a file object
my_file.puts(INPUT)           # put the selection in it
my_file.flock(File::LOCK_UN)  # unlock the file
report = `"#{JSC}" "#{JSLINT}" "#{PREFS}" "#{LAUNCHER}" -- "#{path}"`
File.delete(path)

# NOTE add TextMate links to report
report = report.gsub(/at line ([0-9]{1,}) character ([0-9]{1,})/, "<a href=\"txmt:\/\/open?line=\\1\&column=\2\">at line \\1 character \\2<\/a>")

# NOTE Fix the file path in the report
report = report.gsub(/#{path}/, "#{FILEPATH}")

html = <<REPORT
<html>
  <head>
    <title>JavaScript Lint Results</title>
    <style type="text/css">
      body {
        font-size: 13px;
      }
      
      pre,
      code {
        background-color: #eee;
        color: #400;
        margin: 3px 0;
      }
      
      h1,
      h2 {
        margin: 0 0 5px;
      }
      
      h1 {
          font-size: 20px;
      }
      h2 {
          font-size: 16px;
      }
      
      span.warning {
        color: #c90;
        text-transform: uppercase;
        font-weight: bold;
      }
      
      span.error {
        color: #900;
        text-transform: uppercase;
        font-weight: bold;
      }
      
      ul {
        margin: 10px 0 0 20px;
        padding: 0;
      }
      
      li {
        margin: 0 0 10px;
      }
    </style>
  </head>
  <body>
    <h1>JavaScript Lint</h1>
    
    <ul>
      #{report}
    </ul>
  </body>
</html>  
REPORT

puts html