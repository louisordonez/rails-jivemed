class Api::V1::SchedulesController < ApplicationController
  def index
    schedules = Schedule.all

    render json: {
             schedules:
               schedules.map do |schedule|
                 {
                   schedule: schedule,
                   user: User.find_by(id: schedule[:user_id])
                 }
               end
           },
           status: :ok
  end
end
