#!/usr/bin/env ruby
require 'date'
OS_VERSIONS = %w(18.04)
NGINX_VERSIONS = %w(1.20.1)
# NGINX_VERSIONS = %w(1.20.1 1.18.0 1.16.1 1.14.2)
PASSENGER_VERSIONS = %w(6.0.9 6.0.8 6.0.7 6.0.6 6.0.5 6.0.4 6.0.3 6.0.2 6.0.1 6.0.0 5.3.7 5.3.6 5.3.5 5.3.4 5.3.3 5.3.2 5.3.1 5.3.0)

def build_and_extract(os_version, nginx_version, passenger_version)
  puts "#{DateTime.now} - COMPILING & EXTRACTING [OS:#{os_version}] [NGINX:#{nginx_version}] [PASSENGER:#{passenger_version}]"
  expected_filenames = [
    "#{Dir.pwd}/output/binaries/ubuntu/#{os_version}/x86_64/nginx-#{nginx_version}.tar.gz",
    "#{Dir.pwd}/output/binaries/ubuntu/#{os_version}/x86_64/nginx-#{nginx_version}-passenger-#{passenger_version}.tar.gz",
    # "#{Dir.pwd}/output/binaries/ubuntu/#{os_version}/x86_64/nginx-#{nginx_version}-passenger-enterprise-#{passenger_version}.tar.gz",
  ]
  if expected_filenames.all? { |expected_filename| File.exist?(expected_filename) }
    puts "  #{DateTime.now} - DONE"
  else
    puts "  #{DateTime.now} - COMPILING"
    success = system("./compile_nginx.sh #{os_version} #{nginx_version} #{passenger_version}")
    raise "Failed to compile [OS:#{os_version}] [NGINX:#{nginx_version}] [PASSENGER:#{passenger_version}]" unless success
    puts "  #{DateTime.now} - EXTRACTING"
    success = system("./extract_nginx.sh #{os_version} #{nginx_version} #{passenger_version}")
    raise "Failed to extract [OS:#{os_version}] [NGINX:#{nginx_version}] [PASSENGER:#{passenger_version}]" unless success
    puts "  #{DateTime.now} - DONE"
  end
end

puts "#{DateTime.now} - STARTING"
OS_VERSIONS.each do |os_version|
  NGINX_VERSIONS.each do |nginx_version|
    PASSENGER_VERSIONS.each do |passenger_version|
      build_and_extract(os_version, nginx_version, passenger_version)
    end
  end
end
puts "#{DateTime.now} - COMPLETE"
