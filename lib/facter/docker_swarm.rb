require 'facter'
require 'json'

Facter.add(:docker_worker_token) do
  setcode do
    if Facter::Util::Resolution.which('docker')
       Facter::Util::Resolution.exec(
        'docker swarm join-token worker -q'
      ).chomp
    end
  end
end

Facter.add(:docker_manager_token) do
  setcode do
    if Facter::Util::Resolution.which('docker')
      Facter::Util::Resolution.exec(
        'docker swarm join-token manager -q'
      ).chomp
    end
  end
end
