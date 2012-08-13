require 'puppet_exec'
require 'mocha_standalone'

describe PuppetExec do 

  let(:puppet_modules) { File.join('boxes', 'fake', 'modules') }
  let(:puppet_deps) { File.join('boxes', 'fake', 'puppet_deps') }
  let(:root_path) { File.join('boxes') }
  let(:puppet_exec) { PuppetExec.new(File.join('boxes'), 'fake' ) }

  before { File.expects(:exists?).with(puppet_deps).returns(true) }

  it "should set the module path for a given project" do
      puppet_exec.modulepath.should == puppet_modules
  end

  it "should get the puppet modules from a file" do
    File.expects(:read).with(puppet_deps).returns("some-dep\nanother-dep")
    puppet_exec.dependencies.should == ['some-dep','another-dep']
  end

  it "should call puppet module to install modules given deps found in puppet_deps" do 
    File.expects(:read).with(puppet_deps).returns("some-dep")
    Kernel.expects(:system).with "puppet module install --modulepath boxes/fake/modules some-dep"
    puppet_exec.install_modules
  end

  it "should do nothing if puppet_deps is not found" do
    File.expects(:exists?).with(puppet_deps).returns(false)
    puppet_exec.dependencies.should == []
  end

end
