class Gallery < ActiveRecord::Base
  validates :secret,
    :format => { :with => /\A[a-zA-Z0-9]+\z/, :message => "only allows letters and numbers"},
    :length => { :in => (6..100) },
    :uniqueness => true,
    :presence => true

  def self.random_secret
    (0...12).map{ (65 + rand(26)).chr }.join
  end
end
