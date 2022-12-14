class Api::V1::DepartmentsController < ApplicationController
  before_action :set_department, only: %i[show update destroy]
  before_action :restrict_user, only: %i[create update]

  def index
    departments = Department.all

    render json: { departments: departments }, status: :ok
  end

  def show
    render json: { department: @department }, status: :ok
  end

  def create
    name = remove_whitespace(department_params[:name])
    department = Department.new(department_params.merge(name: name))

    unless department_exists?(name)
      if department.save
        render json: { department: department }, status: :created
      else
        show_errors(department)
      end
    end
  end

  def update
    name = remove_whitespace(department_params[:name])

    unless department_exists?(name)
      if @department.update(department_params.merge(name: name))
        render json: { department: @department }, status: :ok
      else
        show_errors(@department)
      end
    end
  end

  def destroy
    @department.destroy

    render json: { department: @department }, status: :ok
  end

  private

  def department_exists?(name)
    if Department.exists?(name: name)
      render json: {
               errors: {
                 messages: ['Department already exists.']
               }
             },
             status: :unprocessable_entity
    end
  end

  def set_department
    @department = Department.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
             errors: {
               messages: ['Record not found.']
             }
           },
           status: :not_found
  end

  def department_params
    params.require(:department).permit(:name)
  end
end
