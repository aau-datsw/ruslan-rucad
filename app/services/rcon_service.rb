class RconService
  attr_accessor :server, :ip, :port, :rcon_password

  def initialize(**args)
    args.each { |k, v| self.send("#{k}=", v) if self.respond_to?("#{k}=") }

    return if self.server.blank?

    self.ip ||= self.server.ip
    self.port ||= self.server.port
    self.rcon_password ||= self.server.rcon_password
  end

  def run(cmd, &block)
    raise ArgumentError, 'Command should be a non-empty string' if cmd.chomp.blank?

    rcon_string = "rcon -H #{self.ip} -p #{self.port}"
    rcon_string = "#{rcon_string} -P #{self.rcon_password}" if self.rcon_password.present?
    rcon_string = "#{rcon_string} #{cmd || 'status'}"

    Rails.logger.debug "Running `#{cmd}` on #{self.server.hostname}"
    Open3.popen3(rcon_string, &block)
  end
end
