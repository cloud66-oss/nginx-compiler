#!/usr/bin/env ruby
require 'date'
RELEASE_VERSION = ARGV[0]
#OS_VERSIONS = %w(18.04)
OS_VERSIONS = %w(18.04 20.04)
NGINX_VERSIONS = %w(1.22.0)
PASSENGER_VERSIONS = %w(6.0.14)

raise "Must provide release number as first argument" if RELEASE_VERSION.nil?

def build_and_extract(os_version, nginx_version, passenger_version, release_version)
  puts "#{DateTime.now} - COMPILING & EXTRACTING [OS:#{os_version}] [NGINX:#{nginx_version}] [PASSENGER:#{passenger_version}] [RELEASE:#{release_version}]"
  expected_filenames = [
    "#{Dir.pwd}/output/binaries/ubuntu-#{os_version}-nginx-#{release_version}.tar.gz",
  ]
  expected_filenames << "#{Dir.pwd}/output/binaries/ubuntu-#{os_version}-passenger-enterprise-#{release_version}.tar.gz" if include_passenger_enterprise?(passenger_version)
  if expected_filenames.all? { |expected_filename| File.exist?(expected_filename) }
    puts "  #{DateTime.now} - DONE"
  else
    puts "  #{DateTime.now} - COMPILING"
    success = system("./compile_nginx.sh #{os_version} #{nginx_version} #{passenger_version} #{release_version}")
    raise "Failed to compile [OS:#{os_version}] [NGINX:#{nginx_version}] [PASSENGER:#{passenger_version}] [RELEASE:#{release_version}]" unless success
    puts "  #{DateTime.now} - EXTRACTING"
    success = system("./extract_nginx.sh #{os_version} #{nginx_version} #{passenger_version} #{release_version}")
    raise "Failed to extract [OS:#{os_version}] [NGINX:#{nginx_version}] [PASSENGER:#{passenger_version}] [RELEASE:#{release_version}]" unless success
    puts "  #{DateTime.now} - DONE"
  end
end

def include_passenger_enterprise?(passenger_version)
  return File.exist?("passenger_enterprise/passenger-enterprise-license") && File.exist?("passenger_enterprise/passenger-enterprise-server-#{passenger_version}.tar.gz")
end

puts "#{DateTime.now} - STARTING"
OS_VERSIONS.each do |os_version|
  NGINX_VERSIONS.each do |nginx_version|
    PASSENGER_VERSIONS.each do |passenger_version|
      build_and_extract(os_version, nginx_version, passenger_version, RELEASE_VERSION)
    end
  end
end
puts "#{DateTime.now} - COMPLETE"
