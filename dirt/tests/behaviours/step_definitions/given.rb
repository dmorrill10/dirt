Given(/^a step that is unimplemented$/) do
  pending 'Finish defining this test!'
end

Given(/^the following directories exist:$/) do |table|
  table.hashes.each do |h|
    FileUtils.mkdir_p(h[:path])
  end
end

Given(/^the default structure exists in "(.*?)"$/) do |project_dir|
  Samling::CreateDefaultStructure.run(project_dir)
end