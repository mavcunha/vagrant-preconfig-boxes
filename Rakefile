require 'vagrant'

Dir['lib/**/*.rb'].each { |library| require_relative library }

BOXES = Dir[File.join(File.dirname(__FILE__),'/boxes/*/')].map { |f| File.basename f}

task :default => [:help]

BOXES.each do |proj|
  task "#{proj}.setup" do
    Rake::Task[:puppet_modules].invoke(proj.to_s)
  end

  task "#{proj}.provision" do
    Rake::Task["#{proj}.setup"].invoke
    Rake::Task[:vm_up].invoke(proj.to_s)

    puts "You might now go to your box directory " + proj_dir(proj)
    puts "and connect to it by 'vagrant ssh'"
  end

  task "#{proj}.clean" do
    Rake::Task[:clean].invoke(proj.to_s)
  end

end

task :boxes do
  puts "Boxes found:"
  BOXES.each do |p|
    puts "\t#{p}"
  end
end

task :status do
  puts "Showing status of all boxes"
  BOXES.each do |p|
    puts "#{p}: " + vg_env(p).primary_vm.state.to_s
  end
end

task :clean, :project do |task, args|
  puts "Cleaning up #{args[:project]} box"
  vg_env(args[:project]).cli('destroy','--force')
  FileUtils.rm_r Dir[File.join(proj_dir(args[:project]), 'modules')]
end

task :clean_all do
  puts "Cleaning up all boxes"
  BOXES.each do |p|
    Rake::Task[:clean].reenable
    Rake::Task[:clean].invoke p
  end
end

task :puppet_modules, :project do |task, args|
  puppet = PuppetExec.new(boxes_path, args[:project])
  if !puppet.dependencies.empty?
    FileUtils.mkdir puppet.modulepath unless Dir.exists?(puppet.modulepath)
    puts "Installing puppet module dependencies on #{args[:project]}..." 
    puppet.install_modules
  end
end

task :vm_up, :project do |task, args|
  puts "Issuing a vagrant up, this can take several minutes..."
  vg_env(args[:project]).cli 'up'
  puts "Finished vagrant up."
end


task :help do
  puts HELP
end

task :test do
  sh 'bundle exec rspec spec'
end

def boxes_path 
  File.realpath(File.join(File.dirname(__FILE__), 'boxes'))
end

def vg_env(project)
  Vagrant::Environment.new(:cwd => proj_dir(project))
end

def proj_dir(project)
  File.join(boxes_path, project)
end



BEGIN {
HELP=<<-'EOH'
 Run 'rake boxes' to list all available boxes. Here the tasks available

 rake MYBOX.setup       Will install puppet deps
 rake MYBOX.provision   Runs setup and vagrant up
 rake MYBOX.clean       Will destroy the VM and delete downloaded files.
 rake clean_all         Will perform clean for all boxes
 rake status            Vagrant status for all boxes.
 rake test              Runs all tests on spec/ directory.
 rake boxes             Lists all boxes.
 rake help              Display this help message.

EOH

}
