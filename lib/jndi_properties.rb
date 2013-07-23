require 'java'
import javax.naming.InitialContext

module JndiProperties
  def self.getProperty(name)
    begin
      env.lookup(name).to_s
    rescue
      nil
    end
  end

  def self.[](name)
    getProperty(name)
  end
  private

  def self.env
    context = InitialContext.new
    environment = context.lookup 'java:comp/env'
    environment
  end
end