json.extract! port, :id, :host_id, :name, :shutdown, :vrf, :vlan, :ipaddr, :netmask, :description, :configured, :created_at, :updated_at
json.url port_url(port, format: :json)
