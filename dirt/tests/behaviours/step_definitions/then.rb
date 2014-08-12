Then(/^it should run "(.*?)"$/) do |command|
  FakeFS.deactivate!
  history.should include command.shellsplit
  FakeFS.activate!
end

Then(/^it should run git add on exactly the following paths in "(.*?)":$/) do |base_path, table|
  commands = table.hashes.collect do |h|
    path = Pathname.new(base_path) + Pathname.new(h[:path])

    command = "git add #{path}\n"
  end

  FakeFS.deactivate!
  history.should == commands.shellsplit
  FakeFS.activate!
end

Then(/^there should be exactly the following files|directories in "(.*?)":$/) do |location, table|
  created_files = Dir.glob(location + '/**/*')
  expected_files = table.hashes.collect { |h| (Pathname.new(location) + h[:path]).to_s }

  created_files.should =~ expected_files
end

Then(/^it there should be \.gitkeep files in exactly the following directories of "(.*?)"$/) do |project_directory, table|
  table.hashes.each do |h|
    File.exist?((Pathname.new(project_directory) + h[:path]) + '.gitkeep').should be_true
  end
end

Then(/^there should be files for "(.*?)" from templates:$/) do |project_name, table|
  created_files = table.hashes.collect do |h|
    File.exists?(h[:path]).should be_true
    File.read(h[:path])
  end

  FakeFS.deactivate!
  templates = table.hashes.collect do |h|
    File.read("./config/templates/#{h[:template]}").gsub('<project_name>', project_name)
  end
  FakeFS.activate!

  created_files.should =~ templates
end