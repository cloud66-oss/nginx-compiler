#!/usr/bin/env ruby
# coding: utf-8

require 'fileutils'

files = Dir["/usr/lib/nginx/modules/*"]
files_array = files.map do |file|
  include_name = nil
  include_filename_without_order = nil
  include_filename_with_order = nil
  case
  when file.include?("ndk")
    include_name = file
    include_filename = file.delete_prefix("/usr/lib/nginx/modules/ndk_").delete_suffix("_module.so").gsub("_", "-")
    include_filename_without_order = "mod-" + include_filename + "-ndk.conf"
    include_filename_with_order = "10-" + include_filename_without_order
  when file.include?("ngx")
    include_name = file
    include_filename = file.delete_prefix("/usr/lib/nginx/modules/ngx_").delete_suffix("_module.so").gsub("_", "-")
    include_filename_without_order = "mod-" + include_filename + ".conf"
    include_filename_with_order = "50-" + include_filename_without_order
  end
  [include_filename_without_order, include_filename_with_order, include_name]
end

FileUtils.mkdir_p("/usr/share/nginx/modules-available")
FileUtils.mkdir_p("/etc/nginx/modules-enabled")
files_array.each do |include_filename_without_order, include_filename_with_order, include_name|
  include_filename_without_order = "/usr/share/nginx/modules-available/#{include_filename_without_order}"
  include_contents = "load_module #{include_name};"
  File.open(include_filename_without_order, 'w') { |file| file.puts(include_contents) }

  include_filename_with_order = "/etc/nginx/modules-enabled/#{include_filename_with_order}"
  File.symlink(include_filename_without_order, include_filename_with_order)
end
