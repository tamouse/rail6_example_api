class Person
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :first_name, :string
  attribute :last_name, :string
  attribute :birthdate, :datetime

  define_model_callbacks :execute

  # before_execute :action_before_execute
  # after_execute :action_after_execute
  around_execute :action_around_execute

  validates :last_name, presence: true
  validate do |person|
    return if person.birthdate.nil?
    return unless person.birthdate < 1.day.ago

    errors.add(:birthdate, "Not old enough")
  end

  def initialize(attrs = {})
    super(attrs)
  end

  def execute
    return unless valid?

    run_callbacks :execute do
      Rails.logger.info "#{model_name} executing!!"
    end
    self
  end

  def action_before_execute
    Rails.logger.info "#{model_name} before execute"
  end

  def action_after_execute
    Rails.logger.info "#{model_name} after execute"
  end

  def action_around_execute
    action_before_execute
    yield
    action_after_execute
  end

  def i18n_scope
    'services.person'.to_sym
  end
end
