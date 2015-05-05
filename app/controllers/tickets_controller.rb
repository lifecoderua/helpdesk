class TicketsController < ApplicationController
  load_and_authorize_resource
  before_action :set_ticket, only: [:show, :update]

  # GET /tickets
  # GET /tickets.json
  def index
    # params[:q] ||= {}
    # @q = Ticket.ransack(params[:q])
    @tickets = @q.result(distinct: true)
  end

  # displays
  def display
    if params[:display].to_i == Status.displays[:fresh]
      @tickets = Ticket.where(owner: nil)
    else
      status_list = Status.where(display: params[:display])
      @tickets = Ticket.where(status: status_list)
    end

    render :index
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def show
    unless current_staff.nil?
      @statuses = Status.all
      @staff_users = Staff.all
    end
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
        TicketMailer.ticket_created(@ticket).deliver_now

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
      notify_user = false
      update_params = passed_params[:ticket_updates_attributes]['0']

      case params[:commit]
        when 'Update and Close'
          # Assume Staff `cancel` ticket on close, and Customer `completes` by default;
          # Staff is still able to `complete` ticket with the implicit Status selection on update
          status = current_staff.nil? ? Status.find_by_role(Status.roles[:completed])
            :  Status.find_by_role(Status.roles[:cancelled])
          @ticket.status = status
          passed_params[:ticket_updates_attributes]['0'][:status_id] = status.id
        else
          if current_staff.nil?
            @ticket.set_status_by_role(Status.roles[:waiting_for_staff_response])
          end
      end

      unless current_staff.nil?
        # set the user performing update
        passed_params[:ticket_updates_attributes]['0'][:editor_id] = current_staff.id
        # notify Customer on reply and update status
        update_body = update_params[:body]
        if update_body.present?
          notify_user = true
          # if the body passed we want to set the new status, or the :waiting_for_customer if the status change not passed
          @ticket.status_id = update_params[:status_id].present? ? update_params[:status_id]
            : Status.find_by_role(Status.roles[:waiting_for_customer]).id
        else
          @ticket.status_id = update_params[:status_id] if update_params[:status_id].present?
        end

        @ticket.staff_id = update_params[:staff_id] if update_params[:staff_id].present?
      end

      if @ticket.update(passed_params)
        TicketMailer.ticket_updated(@ticket, update_body).deliver_now if notify_user

        format.html { redirect_to @ticket, notice: 'Ticket was successfully updated.' }
        format.json { render :show, status: :ok, location: @ticket }
      else
        format.html { redirect_to @ticket, notice: 'Ticket update failed' }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  def autocomplete
    tickets = Ticket.lookup_by_slug params[:term]
    @list = []
    tickets.each{ |ticket| @list.push({id: ticket_path(ticket), value: ticket.slug}) }

    render json: @list
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.find_by_slug(params[:slug])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ticket_params
      ticket_update_whitelist = current_staff.nil? ? [:body] : [:body , :status_id, :staff_id]

      params.require(:ticket).permit(:subject, :body, :customer_name, :email, :department, :staff_id,
         ticket_updates_attributes: ticket_update_whitelist
      )
    end
end
