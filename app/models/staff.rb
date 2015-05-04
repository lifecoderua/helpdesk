class Staff < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # , :registerable, :validatable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable
  attr_accessor :login

  validates :username,
            :presence => true,
            :uniqueness => {
                :case_sensitive => false
            }

  has_many :tickets

  def to_s
    username
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions.to_h).first
    end
  end

end
