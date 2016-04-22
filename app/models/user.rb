class User < ActiveRecord::Base
  # get modules to help with some functionality
  include CreameryHelpers::Validations

  # Relationships
  belongs_to :employee

  has_secure_password

  # Validations
  validates_uniqueness_of :email, case_sensitive: false
  validates_format_of :email, :with => /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))\z/i, :message => "is not a valid format"
  validate :employee_is_active_in_system, on: :update

  def self.authenticate(email,password)
        find_by_email(email).try(:authenticate, password)
  end
  
  #NEED TO WRITE AND TEST A ROLE METHOD

  # for use in authorizing with CanCan
  ROLES = [['Administrator', :admin],['Manager', :manager], ['Employee', :employee]]

  def role?(authorized_role)
    return false if (self.employee.nil? || self.employee.role.nil?)
    #
    self.employee.role.downcase.to_sym == authorized_role
  end

  private
  def employee_is_active_in_system
    is_active_in_system(:employee)
  end

end
