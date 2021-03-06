class Request < ApplicationRecord
  belongs_to :customer, counter_cache: true
  belongs_to :user
  has_one :freight_capacity, as: :shippable
  has_one :location, as: :locatable
  has_one :destination, as: :destinable

  after_create :set_status

  def set_status
    @request = self

    @customer_confirmation = @request.customer_confirmation
    @user_confirmation = @request.user_confirmation

    if @customer_confirmation == true && @user_confirmation == true
        @request.status = "Accepted"
    elsif @customer_confirmation == true && @user_confirmation == false
        @request.status = "Pending"
    else
      @request.status = "Declined"
    end

    @request.save!
  end


end
