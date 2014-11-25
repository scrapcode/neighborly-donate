class ProjectFinancialByService
  include Enumerable

  attr_accessor :project, :payment_service

  alias_method :payment_method, :payment_service

  def initialize(project, payment_service = nil)
    @project, @payment_service = project, payment_service
  end

  def each(&block)
    contributions.each do |contribution|
      block.call(contribution)
    end
  end

  def net_amount
    contributions.to_a.sum(&:net_value) - platform_fee
  end

  def payment_service_fee
    contributions.sum(:payment_service_fee)
  end

  def platform_fee
    contributions.sum(:value) * Configuration[:platform_fee]
  end

  def total_contributions
    contributions.length
  end

  private

  def contributions
    @contributions ||= if payment_service.present?
      project.contributions.with_state(:confirmed)
        .where(payment_method: payment_service)
    else
      project.contributions.with_state(:confirmed)
    end
  end
end
