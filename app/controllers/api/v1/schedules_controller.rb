class Api::V1::SchedulesController < ApplicationController
  before_action :set_schedule, only: %i[show update destroy]
  before_action :restrict_patient, only: %i[create update destroy]
  before_action :restrict_admin, only: %i[create update destroy]

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

  def create
    date = Date.parse(schedule_params[:date])
    schedule_exists = @current_user.schedules.find_by(date: date)

    if schedule_exists
      render json: {
               errors: {
                 messages: ['Schedule already exists.']
               }
             },
             status: :unprocessable_entity
    else
      schedule =
        Schedule.new(
          schedule_params.merge(user_id: @current_user[:id], date: date)
        )

      if schedule.save
        render json: {
                 user: @current_user,
                 role: @current_user.role,
                 schedules: schedule
               },
               status: :created
      else
        render json: {
                 errors: {
                   messages: schedule.errors.full_messages
                 }
               },
               status: :unprocessable_entity
      end
    end
  end

  def update
    if @schedule.update(
         schedule_params.merge(date: Date.parse(schedule_params[:date]))
       )
      render json: {
               user: @current_user,
               role: @current_user.role,
               schedules: @schedule
             },
             status: :ok
    else
      render json: {
               errors: {
                 messages: @schedule.errors.full_messages
               }
             },
             status: :unprocessable_entity
    end
  end

  def destroy
    @schedule.destroy

    render json: {
             user: @current_user,
             role: @current_user.role,
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
    params.require(:schedule).permit(:user_id, :date)
  end
end
