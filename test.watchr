#
# 'autotest' for riot
# install watchr
# $ sudo gem install watchr
#
# Run With:
# $ watchr test.watchr
#

# --------------------------------------------------
# Helpers
# --------------------------------------------------

def run(path)
  if File.exist? path
    puts(path) ; system("ruby " + path)    
  end
end

def run_all_tests
  system( "padrino rake test" )
end

# --------------------------------------------------
# Watchr Rules
# --------------------------------------------------

# Controllers
watch("^app/controllers/(.*).rb") { |m| run("test/controllers/#{m[1]}_controller_test.rb")}
watch("^test/controllers/(.*)_test.rb") { |m| run("test/controllers/#{m[1]}_test.rb")}

# Models
watch("^app/models/(.*).rb") { |m| run("test/models/#{m[1]}_test.rb")}
watch("^test/models/(.*)_test.rb") { |m| run("test/models/#{m[1]}_test.rb")}

# Test Config
watch("test.*/test_config\.rb") { run_all_tests }

# Lib
watch("^lib.*/(.*)\.rb") { |m| run("test/#{m[1]}_test.rb") }
watch("^test/(.*)_test\.rb")  { |m| run("test/#{m[1]}_test.rb")}

# Views
watch("^app/views/(.*)/(.*).(.*)") { |m| run("test/controllers/#{m[1]}_controller_test.rb")}

# --------------------------------------------------
# Signal Handling
# --------------------------------------------------
# Ctrl-\
Signal.trap('QUIT') do
  puts " --- Running all tests ---\n\n"
  run_all_tests
end

# Ctrl-C
Signal.trap('INT') { abort("\n") }
