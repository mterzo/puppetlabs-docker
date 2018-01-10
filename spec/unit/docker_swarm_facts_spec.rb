require 'spec_helper'
require 'json'

describe Facter::Util::Fact, type: :fact do
  before :each do
    Facter.clear
    Facter::Util::Resolution.stubs(:which).with('docker').returns('/usr/bin/docker')
  end
  after :each do
    Facter.clear
  end

  ['manager', 'worker'].each do |role|
    describe "docker swarm #{role} token" do
      before do
        docker_value = File.read(fixtures('facts', "docker_#{role}_token"))
        Facter::Util::Resolution.stubs(:exec).with("docker swarm join-token #{role} -q").returns(docker_value)
      end
      it do
        value = File.read(fixtures('facts', "docker_#{role}_token")).chomp
        expect(Facter.fact("docker_#{role}_token").value).to eq(
          value
        )
      end
    end

    describe "docker swarm #{role} token not swarm mode" do
      before do
        Facter::Util::Resolution.stubs(:exec).with("docker swarm join-token #{role} -q").returns false
      end
      it do
        expect(Facter.fact("docker_#{role}_token").value).to eq(
          nil
        )
      end
    end
  end
end
