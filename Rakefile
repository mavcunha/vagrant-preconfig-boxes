require 'vagrant'

Dir['lib/**/*.rb'].each { |library| require_relative library }

BOXES = Dir[File.join(File.dirname(__FILE__),'/boxes/*/')].map { |f| File.basename f}

task :default => [:help]

# Individual commands, they apply for a single box.
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
  task "#{proj}.destroy" do
    if confirmed?("destroy #{proj}")
      Rake::Task[:destroy].invoke proj.to_s
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

# Global commands, they apply for all boxes.
task :list do
  puts "Boxes found:"
  BOXES.each do |p|
    puts "\t#{p}"
  end
end

task :suspend do 
  BOXES.each do |b|
    Rake::Task[:vg_cli_exec].reenable
    Rake::Task[:vg_cli_exec].invoke(b, 'suspend')
  end
end

task :status do
  puts "Showing status of all boxes"
  BOXES.each do |p|
    Rake::Task[:single_status].reenable
    Rake::Task[:single_status].invoke p
  end
end

task :destroy do
  if confirmed?('destroy all boxes')
    puts "Destroying all boxes..."
    BOXES.each do |p|
      Rake::Task[:destroy].reenable
      Rake::Task[:destroy].invoke p
      puts "#{p}: destroyed"
    end
    Rake::Task[:status].invoke
  end
end

# Tasks that are invoked internally, although is possible to invoke them
# through the command line.
task :single_status, :project do |t, args|
  print "#{args[:project]}: "
  vg_env(args[:project]).vms.each do |name, vm| 
    print "[#{name}: " + vm.state.to_s + "] "
  end
  puts ""
end

task :vg_cli_exec, [:project, :cmd] do |t,args|
  puts "Running #{args[:cmd]} on #{args[:project]} box"
  vg_env(args[:project]).cli(args[:cmd])
end

task :destroy, :project do |task, args|
  puts "Destroying #{args[:project]} box"
  vg_env(args[:project]).cli('destroy','--force')
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
There are two ways to issue commands, for all boxes or for a single box.

For all boxes:
 rake list             Lists all boxes.
 rake status            Vagrant status for all boxes.
 rake destroy           Destroy all boxes! Be careful.

For single boxes use [box name].[command], i.e. 'rake dev.up'
 rake [box].setup       Will run puppet and setup it's modules dependencies.
 rake [box].provision   Will run 'setup' and than 'vagrant provision' on the box.
 rake [box].destroy     Destroy a specific box.
 rake [box].status      Shows current status.
 rake [box].suspend     Suspend a box.
 rake [box].resume      Resume a box.
 rake [box].ssh         SSH into a box.
 rake [box].reload      Will reboot a box.
 rake [box].halt        Will poweroff a box.
 rake [box].up          Will start a box, box will be created if needed.
 
 rake -T                Will list all individual commands for all available boxes.

 rake help              Display this help message.

EOH
}
