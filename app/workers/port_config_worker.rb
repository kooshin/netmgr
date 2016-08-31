class PortConfigWorker
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

    @ios.exp_send %{
vrf definition #{@port.vrf}
 address-family ipv4
    }

    @ios.exp_send %{
interface #{@port.name}
    }

    if @port.shutdown
      @ios.exp_send %{
shutdown
      }
    else
      @ios.exp_send %{
no shutdown
      }
    end

    @ios.exp_send %{
vrf forwarding #{@port.vrf}
    }
    if /\./ === @port.name
      # only subinterface
      @ios.exp_send %{
encapsulation dot1Q #{@port.vlan}
      }
    end
    @ios.exp_send %{
ip address #{@port.ipaddr} #{@port.netmask}
    }

    if @port.description.blank?
      @ios.exp_send %{
no description
      }
    else
      @ios.exp_send %{
description #{@port.description}
}
    end

    @ios.exp_send 'end'

    @ios.putline "copy running-config startup-config\r", no_trim: true

    @port.configured = true
    @port.save!
  end

end
