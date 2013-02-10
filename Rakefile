require 'vagrant'

Dir['lib/**/*.rb'].each { |library| require_relative library }

BOXES = Dir[File.join(File.dirname(__FILE__),'/boxes/*/')].map { |f| File.basename f}

task :default => [:help]

BOXES.each do |proj|

  desc "Fetch puppet modules for a #{proj} box" 
  task "#{proj}.setup" do
    Rake::Task[:puppet_modules].invoke(proj.to_s)
  end

  desc "Runs #{proj}.setup and #{proj}.provision" 
  task "#{proj}.provision" do
    Rake::Task["#{proj}.setup"].invoke
    Rake::Task[:vg_cli_exec].invoke(proj.to_s, 'provision')
  end

  desc "Destroy #{proj} box" 
  task "#{proj}.clean" do
    if confirmed?("destroy #{proj}")
      Rake::Task[:clean].invoke proj.to_s
    end
  end

  desc "Show status of #{proj} box"
  task "#{proj}.status" do
    Rake::Task[:single_status].invoke proj.to_s
  end

  ['suspend','resume','ssh','reload','halt','up'].each do |cmd|
    desc "#{cmd.capitalize} #{proj} box"
    task "#{proj}.#{cmd}" do 
      Rake::Task[:vg_cli_exec].invoke(proj.to_s, cmd)
    end
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
    Rake::Task[:single_status].reenable
    Rake::Task[:single_status].invoke p
  end
end

task :clean_all do
  if confirmed?('destroy all boxes')
    puts "Destroying all boxes..."
    BOXES.each do |p|
      Rake::Task[:clean].reenable
      Rake::Task[:clean].invoke p
      puts "#{p}: destroyed"
    end
    Rake::Task[:status].invoke
  end
end

task :single_status, :project do |t, args|
  puts "#{args[:project]}: " + vg_env(args[:project]).primary_vm.state.to_s
end

task :vg_cli_exec, [:project, :cmd] do |t,args|
  puts "Running #{args[:cmd]} on #{args[:project]} box"
  vg_env(args[:project]).cli(args[:cmd])
end

task :clean, :project do |task, args|
  puts "Cleaning up #{args[:project]} box"
  vg_env(args[:project]).cli('destroy','--force')
  FileUtils.rm_r Dir[File.join(proj_dir(args[:project]), 'modules')]
end

task :puppet_modules, :project do |task, args|
  puppet = PuppetExec.new(boxes_path, args[:project])
  if !puppet.dependencies.empty?
    FileUtils.mkdir puppet.modulepath unless Dir.exists?(puppet.modulepath)
    puts "Installing puppet module dependencies on #{args[:project]}..." 
    puppet.install_modules
  end
end

task :help do
  puts HELP
end

task :test do
  sh 'bundle exec rspec --color spec'
end

def confirmed?(action)
  print "Are you sure you want to #{action} (Y/N) [N]? "
  return STDIN.gets.chomp == 'Y'
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
 rake boxes             Lists all boxes.
 rake status            Vagrant status for all boxes.
 rake clean_all         Destroy all boxes! Be careful.

 rake -T                To list tasks for single boxes.

 rake help              Display this help message.

EOH
}
