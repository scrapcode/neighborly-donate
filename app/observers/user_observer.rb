class UserObserver < ActiveRecord::Observer
  def before_validation(user)
    set_password(user)
    add_url_protocol(user)
  end

  def after_commit(user)
    calculate_completeness(user)

    if just_created?(user)
      welcome_user(user)
    end
  end

  private

  def set_password(user)
    user.password = SecureRandom.hex(4) unless user.password || user.persisted?
  end

  def add_url_protocol(user)
    return unless user.other_url.present?

    unless URI.parse(user.other_url).scheme
      user.other_url = "http://#{user.other_url}"
    end
  end

  def calculate_completeness(user)
    if user.completeness_progress.to_i < 100
      UpdateCompletenessProgressWorker.perform_async(user.id)
    end
  end

  def welcome_user(user)
    unless user.email =~ /change-your-email\+[0-9]+@neighbor\.ly/
      WelcomeWorker.perform_async(user.id)
    end
  end

  def just_created?(user)
    !!user.send(:transaction_record_state, :new_record)
  end
end
