class Api::V1::AppointmentsController < ApplicationController
  def index
    appointments = Appointment.all

    render json: {
             appointments:
               appointments.map { |appointment|
                 {
                   details: appointment,
                   patient: appointment.user,
                   schedule: appointment.schedule,
                   doctor: appointment.schedule.user
                 }
               }
           }
  end
end
