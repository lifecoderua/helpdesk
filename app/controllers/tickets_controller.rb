class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :update]

  # GET /tickets
  # GET /tickets.json
  def index
    @tickets = Ticket.all
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def show
    @statuses = Status.all
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.new
    @departments = Department.all
  end

  # POST /tickets
  # POST /tickets.json
  def create
    @ticket = Ticket.new(ticket_params)
    @ticket.set_status_by_role(Status.roles[:waiting_for_staff_response])

    respond_to do |format|
      if @ticket.save
        format.html { redirect_to @ticket, notice: 'Ticket was successfully created.' }
        format.json { render :show, status: :created, location: @ticket }
      else
        format.html { render :new }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tickets/1
  # PATCH/PUT /tickets/1.json
  def update
    respond_to do |format|
      passed_params = ticket_params

      if current_staff.nil?
        case params[:commit]
          when 'Update and Close'
            status = Status.find_by_role(Status.roles[:completed])
            @ticket.status = status
            passed_params[:ticket_updates_attributes]['0'][:status_id] = status.id
          else
            @ticket.set_status_by_role(Status.roles[:waiting_for_staff_response])
        end
      else
        # ToDo: staff-related logic
      end

      if @ticket.update(passed_params)
        format.html { redirect_to @ticket, notice: 'Ticket was successfully updated.' }
        format.json { render :show, status: :ok, location: @ticket }
      else
        format.html { redirect_to @ticket, notice: 'Ticket update failed' }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.find_by_slug(params[:slug])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ticket_params
      params.require(:ticket).permit(:subject, :body, :customer_name, :email,
         ticket_updates_attributes: [
             :body #, :status_id, :owner
         ]
      )
    end
end
