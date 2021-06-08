#!/usr/bin/env ruby

# NOTE: there doesn't seem to be any mention of this anywhere other than here:
# https://github.com/phusion/passenger_homebrew_automation/blob/master/Formula/passenger.rb
# NOTE: assume script is running in the root of passenger source code

files_with_magic_comments = `grep -R 'Magic comment: begin' pkg/fakeroot -l`
raise "Failed to list files with magic comments" unless $?.exitstatus == 0
files_with_magic_comments = files_with_magic_comments.split("\n").map(&:strip)

known_files_with_magic_comments = [
  # Passenger
  "pkg/fakeroot/usr/share/passenger/ngx_http_passenger_module/config",
  "pkg/fakeroot/usr/sbin/passenger-status",
  "pkg/fakeroot/usr/sbin/passenger-memory-stats",
  "pkg/fakeroot/usr/lib/ruby/vendor_ruby/phusion_passenger/rack_handler.rb",
  "pkg/fakeroot/usr/bin/passenger",
  "pkg/fakeroot/usr/bin/passenger-install-apache2-module",
  "pkg/fakeroot/usr/bin/passenger-config",
  "pkg/fakeroot/usr/bin/passenger-install-nginx-module",
  # Passenger Enterprise
  "pkg/fakeroot/usr/share/passenger-enterprise/ngx_http_passenger_module/config",
  "pkg/fakeroot/usr/share/passenger-enterprise/helper-scripts/port-binding-proxy.rb",
  "pkg/fakeroot/usr/sbin/passenger-irb",
  "pkg/fakeroot/usr/bin/flying-passenger",
]

unknown_files_with_magic_comments = files_with_magic_comments - known_files_with_magic_comments
raise "Previously unknown files with magic comments: #{unknown_files_with_magic_comments.inspect}" unless unknown_files_with_magic_comments.empty?

files_to_substitute = known_files_with_magic_comments.map do |s|
  s.delete_prefix("pkg/fakeroot")
end.select do |s|
  File.exist?(s)
end
files_to_substitute_nginx_module_config = files_to_substitute.select do |s|
  s == "/usr/share/passenger/ngx_http_passenger_module/config" ||
  s == "/usr/share/passenger-enterprise/ngx_http_passenger_module/config"
end
files_to_substitute_ruby = files_to_substitute - files_to_substitute_nginx_module_config

NGINX_ADDON_DIR = `passenger-config about nginx-addon-dir`.strip
raise "Failed to get NGINX addon directory from passenger-config" unless $?.exitstatus == 0
RUBY_LIB_DIR = `passenger-config about ruby-libdir`.strip
raise "Failed to get Ruby library directory from passenger-config" unless $?.exitstatus == 0
BIN_DIR = "/usr/bin"

success = system("./dev/install_scripts_bootstrap_code.rb", "--ruby", RUBY_LIB_DIR, *files_to_substitute_ruby)
raise "Failed to bootstrap scripts with --ruby" unless success
success = system("./dev/install_scripts_bootstrap_code.rb", "--nginx-module-config", BIN_DIR, *files_to_substitute_nginx_module_config)
raise "Failed to bootstrap scripts with --nginx-module-config" unless success
