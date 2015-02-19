# Calender Controller
class CalenderController < ApplicationController
  def index
    @show_month = Date.today
    @start_date = @show_month.beginning_of_month
    @start_date_day = @start_date.wday
    @last_day = @show_month.end_of_month
  end

  def change
    @show_month = params[:id].to_date
    @start_date = @show_month.beginning_of_month
    @start_date_day = @start_date.wday
    @last_day = @show_month.end_of_month
  end

  def event_view
    @event = Event.shod(params[:event_id])
  end

  def view_events
    @events = Event.all
  end

  def display_batch_department
    @event = Event.find(params[:format])
    @batches = @event.batches
    @departments = @event.employee_departments
  end  

  def update_event
    @event = Event.find(params[:id])
    if @event.update(params_event)
      flash[:notice] = 'Event updated successfully'
      redirect_to calender_index_path
    end
  end

  private

  def params_event
    params.require(:event).permit!
  end
end
