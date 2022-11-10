class Api::V1::DepartmentsController < ApplicationController
  before_action :set_department, only: %i[show update destroy]

  def index
    deparments = Department.all

    render json: deparments, status: :ok
  end

  def show
    render json: @department, status: :ok
  end

  private

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
