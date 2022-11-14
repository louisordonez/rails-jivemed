class Api::V1::SchedulesController < ApplicationController
  before_action :set_schedule, only: %i[show update destroy]

  def index
    schedules = Schedule.all

    render json: {
             schedules:
               schedules.map do |schedule|
                 user = User.find_by(id: schedule[:user_id])

                 { user: user, role: user.role, schedule: schedule }
               end
           },
           status: :ok
  end

  def show
    user = User.find(@schedule[:user_id])

    render json: {
             user: user,
             role: user.role,
             schedules: @schedule
           },
           status: :ok
  end

  def update
    if @schedule.update(
         schedule_params.merge(date: Date.parse(schedule_params[:date]))
       )
      user = User.find(@schedule[:user_id])

      render json: {
               user: user,
               role: user.role,
               schedules: @schedule
             },
             status: :ok
    else
      render json: {
               errors: {
                 messages: @current_user.errors.full_messages
               }
             },
             status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find(@schedule[:user_id])

    @schedule.destroy

    render json: {
             user: user,
             role: user.role,
             schedules: @schedule
           },
           status: :ok
  end

  private

  def set_schedule
    @schedule = Schedule.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
             errors: {
               messages: ['Record not found.']
             }
           },
           status: :not_found
  end

  def schedule_params
    params.require(:schedule).permit(:date)
  end
end
