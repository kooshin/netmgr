class PortUnconfigWorker
  include Sidekiq::Worker

  def perform(port_id)
    @port = Port.find(port_id)
    @host = @port.host

    @ios = Expect4r::Ios.new_ssh(
      host: @host.connect,
      user: @host.username,
      pwd: @host.password,
      enable_secret: @host.enable_password
    )

    @ios.login
    @ios.config

    if /\./ === @port.name
      # subinterface
      puts @ios.exp_send %{
interface #{@port.name}
 shutdown
no interface #{@port.name}
      }
    else
      puts @ios.exp_send %{
interface #{@port.name}
 shutdown
 no vrf forwarding
 no description
      }
    end

    @ios.exp_send 'end'

    @ios.putline "copy running-config startup-config\r", no_trim: true

    @port.destroy
  end
end
