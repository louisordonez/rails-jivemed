class Api::V1::SchedulesController < ApplicationController
  before_action :set_schedule, only: %i[show update destroy]

  def index
    schedules = Schedule.all

    render json: {
             schedules:
               schedules.map do |schedule|
                 {
                   user: User.find_by(id: schedule[:user_id]),
                   schedule: schedule
                 }
               end
           },
           status: :ok
  end

  def show
    user = User.find(@schedule[:user_id])
    schedule = user.schedules

    render json: { user: user, schedules: schedule }, status: :ok
  end

  def destroy
    user = User.find(@schedule[:user_id])

    @schedule.destroy

    render json: { user: user, schedules: @schedule }, status: :ok
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
end
