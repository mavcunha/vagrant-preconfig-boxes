Dir['lib/**/*.rb'].each { |library| require_relative library }

BOXES = Dir[File.join(File.dirname(__FILE__),'/boxes/*/')].map { |f| File.basename f}

task :default => [:help]

task :boxes do
  puts BOXES
end

BOXES.each do |proj|

  task "#{proj}.config" do
    Rake::Task[:prepare].invoke(proj.to_s)
  end

end


task :prepare, :project do |task, args|
  puppet = PuppetExec.new(boxes_path, args[:project])
  if !puppet.dependencies.empty?
    FileUtils.mkdir puppet.modulepath if !Dir.exists?(puppet.modulepath)
    puts "Installing puppet module dependencies on #{args[:project]}..." 
    puppet.install_modules
  end
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


BEGIN {
HELP=<<-'EOH'
You shall run ....
EOH

}
