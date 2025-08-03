class UserForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :first_name, :string
  attribute :last_name, :string
  attribute :email, :string
  attribute :phone, :string
  attribute :website, :string
  attribute :bio, :string
  attribute :birth_date, :date
  attribute :country, :string
  attribute :terms_accepted, :boolean, default: false
  attribute :newsletter_subscription, :boolean, default: false
  attribute :profile_visibility, :string, default: "public"

  validates :first_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, format: { with: /\A\+?[\d\s\-\(\)]+\z/, message: "must be a valid phone number" }, allow_blank: true
  validates :website, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "must be a valid URL" }, allow_blank: true
  validates :bio, length: { maximum: 500 }
  validates :birth_date, presence: true
  validates :country, presence: true, inclusion: { in: [ "US", "CA", "UK", "DE", "FR", "AU", "JP" ], message: "%{value} is not a supported country" }
  validates :terms_accepted, acceptance: { message: "must be accepted to continue" }
  validates :profile_visibility, inclusion: { in: %w[public private friends_only] }

  validate :birth_date_not_in_future

  def persisted?
    false
  end

  def country_options
    [
      [ "United States", "US" ],
      [ "Canada", "CA" ],
      [ "United Kingdom", "UK" ],
      [ "Germany", "DE" ],
      [ "France", "FR" ],
      [ "Australia", "AU" ],
      [ "Japan", "JP" ]
    ]
  end

  def profile_visibility_options
    [
      [ "Public", "public" ],
      [ "Private", "private" ],
      [ "Friends Only", "friends_only" ]
    ]
  end

  private

  def birth_date_not_in_future
    return unless birth_date.present?

    if birth_date > Date.current
      errors.add(:birth_date, "cannot be in the future")
    end

    if birth_date < 120.years.ago
      errors.add(:birth_date, "cannot be more than 120 years ago")
    end
  end
end
