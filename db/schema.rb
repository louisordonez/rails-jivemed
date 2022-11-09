# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_11_09_070922) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "departments_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "department_id", null: false
  end

  create_table "fees", force: :cascade do |t|
    t.decimal "amount", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fees_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "fee_id", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "reservation_id", null: false
    t.string "stripe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_id"], name: "index_payments_on_reservation_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "amount"
    t.integer "payment_method"
    t.bigint "user_id", null: false
    t.bigint "schedule_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["schedule_id"], name: "index_reservations_on_schedule_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_id", null: false
  end

  create_table "schedules", force: :cascade do |t|
    t.bigint "doctor_id", null: false
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_schedules_on_doctor_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "appointment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appointment_id"], name: "index_transactions_on_appointment_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "stripe_id"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.boolean "email_verified"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "payments", "reservations"
  add_foreign_key "reservations", "schedules"
  add_foreign_key "reservations", "users"
  add_foreign_key "schedules", "users", column: "doctor_id"
  add_foreign_key "transactions", "reservations", column: "appointment_id"
end
