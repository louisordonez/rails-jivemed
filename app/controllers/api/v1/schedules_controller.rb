class Api::V1::SchedulesController < ApplicationController
  before_action :set_schedule, only: %i[show update destroy]
  before_action :restrict_patient, only: %i[create update destroy]
  before_action :restrict_admin, only: %i[create update destroy]

  def index
    schedules =
      Schedule.all.map do |schedule|
        user = User.find_by(id: schedule[:user_id])

        { schedule: schedule, user: user, role: user.role }
      end

    render json: { schedules: schedules }, status: :ok
  end

  def show
    user = User.find(@schedule[:user_id])
    user = { schedule: @schedule, user: user, role: user.role }

    render json: user, status: :ok
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
      new_schedule_params =
        schedule_params.merge(user_id: @current_user[:id], date: date)
      schedule = Schedule.new(new_schedule_params)

      if schedule.save
        schedule = {
          user: @current_user,
          role: @current_user.role,
          schedules: schedule
        }

        render json: schedule, status: :created
      else
        show_errors(schedule)
      end
    end
  end

  def update
    update_schedule_params =
      schedule_params.merge(date: Date.parse(schedule_params[:date]))

    if @schedule.update(update_schedule_params)
      schedule = {
        user: @current_user,
        role: @current_user.role,
        schedules: @schedule
      }

      render json: schedule, status: :ok
    else
      show_errors(@schedule)
    end
  end

  def destroy
    @schedule.destroy

    schedule = {
      user: @current_user,
      role: @current_user.role,
      schedules: @schedule
    }

    render json: schedule, status: :ok
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
