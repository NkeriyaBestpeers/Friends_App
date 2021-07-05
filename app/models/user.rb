class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image

  GENDER = ["Male", "Female", "Other"]

  validates :gender, inclusion: GENDER
  validates :username, :firstname, :lastname, :gender, :birthday, presence: true
  
  def name
    name = (self.firstname.capitalize + " " + self.lastname.capitalize)
  end

  scope :search_user, -> (search) {where("lower(firstname) LIKE :search OR lower(lastname) LIKE :search OR lower(username) LIKE :search", search: "%#{search.downcase}%")}
  
  scope :registered_users, -> (id) {all.where.not(id: id)} 

  has_many :friendships
  has_many :friends, through: :friendships

  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user

  has_many :friend_requests
  has_many :req_received, through: :friend_requests

end
