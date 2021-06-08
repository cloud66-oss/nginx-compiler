#!/usr/bin/env ruby

require "fileutils"
require "json"

library_name = ARGV[0]
library_version = ARGV[1]
type = ARGV[2]
additional_control_content = ARGV[3] ? JSON.parse(ARGV[3]) : {}

raise "Must specify library name as first argument" if library_name.nil? || library_name.empty?
raise "Must specify library version as second argument" if library_version.nil? || library_version.empty?
raise "Must specify one of \"source\" or \"binary\" as third argument" unless type == "source" || type == "binary"

library_name = library_name + "-source" if type == "source"

before = File.readlines("/tmp/current_state_before", encoding: 'UTF-8').map(&:strip).reject(&:empty?)
after = File.readlines("/tmp/current_state_after", encoding: 'UTF-8').map(&:strip).reject(&:empty?)

if type == "source"
  before = before.select { |s| s.start_with?("/usr/local/build") }
  after = after.select { |s| s.start_with?("/usr/local/build") }
else
  before = before.reject { |s| s.start_with?("/usr/local/build") || s.start_with?("/proc") || s.start_with?("/sys") || s == "/tmp/current_state_before" || s == "/tmp/current_state_after" }
  after = after.reject { |s| s.start_with?("/usr/local/build") || s.start_with?("/proc") || s.start_with?("/sys") || s == "/tmp/current_state_before" || s == "/tmp/current_state_after" }
end

files_deleted = before - after
files_created = after - before

raise "Files deleted (#{library_name} #{library_version}):\n#{files_deleted.join("\n")}" unless files_deleted.empty?
raise "No files created (#{library_name} #{library_version})" if files_created.empty?

puts "Files created (#{library_name} #{library_version}):\n#{files_created.join("\n")}"

deb_directory_name = "/usr/local/deb_sources/#{library_name}_#{library_version}_amd64"
FileUtils.mkdir_p(deb_directory_name)

files_created.each do |created_file| 
  # NOTE: -a preserves everything and --parents creates intermediate directories
  success = system("cp -a --parents #{created_file} #{deb_directory_name}")
  raise "Could not cp #{created_file} to #{deb_directory_name} (#{library_name} #{library_version})" unless success
end

# TODO: debs with source code follow a different format (e.g. debian directory instead of DEBIAN), or the source could just be tarballed.
# For now though it's only being used internally in the Dockerfile, so it doesn't matter.
description = type == "source" ? "source code" : "package"
FileUtils.mkdir_p(File.join(deb_directory_name, "DEBIAN"))
control_content = <<~CONTROL
Package: #{library_name}
Version: #{library_version}
Architecture: amd64
Maintainer: Cloud 66 <eng@cloud66.com>
Description: Cloud 66 #{description} for #{library_name}.
CONTROL
unless additional_control_content.empty?
  additional_control_content = additional_control_content.map { |k, v| "#{k}: #{v}" }.join("\n") + "\n"
  control_content += additional_control_content
end
File.open(File.join(deb_directory_name, "DEBIAN", "control"), 'w') { |file| file.write(control_content) }

unless type == "source"
  postinst_content = <<~POSTINST
  #!/usr/bin/env bash
  if which sudo >/dev/null 2>&1 ; then sudo ldconfig; else ldconfig; fi
  POSTINST
  postinst_location = File.join(deb_directory_name, "DEBIAN", "postinst")
  File.open(postinst_location, 'w') { |file| file.write(postinst_content) }
  FileUtils.chmod(0755, postinst_location)
end

success = system("dpkg-deb --build --root-owner-group #{deb_directory_name}")
raise "Could not create deb file (#{library_name} #{library_version})" unless success

success = system("mv #{deb_directory_name}.deb /usr/local/debs")
raise "Could not move #{deb_directory_name}.deb to /usr/local/debs (#{library_name} #{library_version})" unless success
