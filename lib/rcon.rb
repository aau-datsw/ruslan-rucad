class RconService
  attr_accessor :server, :ip, :port, :rcon_password

  def initialize(**args)
    args.each { |k,v| self.send("#{k}=", v) if self.respond_to?("#{k}=") }

    if self.server.present?
      self.ip ||= self.server.ip
      self.port ||= self.server.port
      self.rcon_password ||= self.server.rcon_password
    end
  end

  def run(cmd, &block)
    rcon_string = "rcon -H #{self.ip} -p #{self.port}"
    rcon_string = "#{rcon_string} -P #{self.rcon_password}" if self.rcon_password.present?

    Open3.popen3(rcon_string, &block)
  end
end
