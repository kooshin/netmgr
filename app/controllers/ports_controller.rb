class PortsController < ApplicationController
  before_action :set_host, only: [:new, :create]
  before_action :set_port, only: [:show, :edit, :destroy, :update]

  # GET /ports
  # GET /ports.json
  def index
    q = params[:q] || {}
    q[:s] = 'host_id asc' unless q.has_key?(:s)
    q[:host_id_eq] = params[:host_id] if params[:host_id]

    @ransack = Port.ransack(q)
    @ports = @ransack.result.includes(:host)
  end

  # GET /ports/1
  # GET /ports/1.json
  def show
  end

  # GET /ports/new
  def new
    @port = @host.ports.build
  end

  # GET /ports/1/edit
  def edit
  end

  # POST /ports
  # POST /ports.json
  def create
    @port = @host.ports.new(port_params)
    @port.configured = false

    respond_to do |format|
      if @port.save
        PortConfigWorker.perform_async(@port.id)

        format.html { redirect_to host_ports_path(@host), notice: 'Port configuration was successfully scheduled.' }
        format.json { render :show, status: :created, location: @port }
      else
        format.html { render :new }
        format.json { render json: @port.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ports/1
  # PATCH/PUT /ports/1.json
  def update
    @port.configured = false

    respond_to do |format|
      if @port.update(port_params)
        PortConfigWorker.perform_async(@port.id)

        format.html { redirect_to host_ports_path(@port.host), notice: 'Port configuration was successfully scheduled.' }
        format.json { render :show, status: :ok, location: @port }
      else
        format.html { render :edit }
        format.json { render json: @port.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ports/1
  # DELETE /ports/1.json
  def destroy
    @port.configured = false
    @port.save!

    respond_to do |format|
      PortUnconfigWorker.perform_async(@port.id)

      format.html { redirect_to host_ports_url(@port.host), notice: 'Port unconfiguration was successfully scheduled.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_host
      @host = Host.find(params[:host_id])
    end

    def set_port
      @port = Port.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def port_params
      params.require(:port).permit(:host_id, :name, :shutdown, :vrf, :vlan, :ipaddr, :netmask)
    end
end
