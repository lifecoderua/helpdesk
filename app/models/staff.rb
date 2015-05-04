class Staff < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # , :registerable, :validatable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable

  has_many :tickets

  def to_s
    email
  end

end
