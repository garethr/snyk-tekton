#! /usr/bin/env ruby

#
# This script generates Tekton Tasks for the currently supported
# set of Snyk images. The Actions all have the same interface.
#

require "erb"
require 'fileutils'


@variants = [
  "DotNet",
  "Golang",
  "Gradle",
  "Maven",
  "Node",
  "PHP",
  "Python",
  "Ruby",
  "Scala",
  "Swift",
]

templatename = File.join("_templates", "BASE.md.erb")
renderer = ERB.new(File.read(templatename))
File.open("README.md", "w") { |file| file.puts renderer.result() }

@variants.each do | variant |
  puts "Generating Task for #{variant}"

  dirname = variant.downcase
  unless File.directory?(dirname)
    FileUtils.mkdir_p(dirname)
  end
  @variant = variant
  {
      "task.yaml.erb" => "#{variant.downcase}.yaml",
      "README.md.erb" => "README.md"
  }.each do |template, output|
    templatename = File.join("_templates", template)
    renderer = ERB.new(File.read(templatename))
    filename = File.join(dirname, output)
    File.open(filename, "w") { |file|
        file.puts renderer.result()
    }
  end
end
