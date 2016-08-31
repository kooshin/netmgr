class Port < ApplicationRecord
  belongs_to :host

  validates :name, presence: true, uniqueness: { scope: [:host_id] }
  validates :vrf, presence: true
  validates :vlan, presence: true
  validates :ipaddr, presence: true
  validates :netmask, presence: true
  validate :must_valid_ipaddr

  def must_valid_ipaddr
    errors.add(:ipaddr, 'Must valid IP Address') unless IPAddress.valid_ipv4?(ipaddr)
    errors.add(:netmask, 'Must valid Netmask') unless IPAddress.valid_ipv4_netmask?(netmask)
  end

end
