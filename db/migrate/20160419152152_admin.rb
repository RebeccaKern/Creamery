class Admin < ActiveRecord::Migration
    def change
    end
  #  factory :employee do
  #   first_name "Ed"
  #   last_name "Gruberman"
  #   ssn { rand(9 ** 9).to_s.rjust(9,'0') }
  #   date_of_birth 19.years.ago.to_date
  #   phone { rand(10 ** 10).to_s.rjust(10,'0') }
  #   role "employee"
  #   active true
  # end
  # def up
  #   admin = Employe.new
  #   admin.first_name = "Admin"
  #   admin.last_name = "Admin"
  #   admin.ssn = { rand(9 ** 9).to_s.rjust(9,'0') }
  #   admin.date_of_birth = 19.years.ago.to_date
    
  #   admin.role = "admin"
  #   admin.save!
  #   admin.email = "admin@example.com"
  #   admin.password = "secret"
  #   admin.password_confirmation = "secret"
  # end

  # def down
  #   admin = User.find_by_email "admin@example.com"
  #   User.delete admin
  # end
end
