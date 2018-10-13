class Server < ApplicationRecord
  def hostname
    [self.ip, self.port].join(':')
  end
  def tv_hostname
    [self.ip, self.tv_port].join(':')
  end
end
