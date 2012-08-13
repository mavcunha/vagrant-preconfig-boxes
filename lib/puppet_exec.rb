require 'fileutils'

class PuppetExec

  def initialize(path_to_boxes, project)
    @path_to_boxes = path_to_boxes
    @project = project
  end

  def modulepath
    path_of 'modules'
  end

  def install_modules
    dependencies.each do |dep|
      Kernel.system "puppet module install --modulepath " + modulepath + " #{dep}"
    end
  end

  def dependencies
    if(File.exists?(path_of 'puppet_deps'))
      File.read(path_of 'puppet_deps').split "\n"
    else
      []
    end
  end

  private
  def path_of(file)
    File.join(@path_to_boxes, @project, file)
  end

end
