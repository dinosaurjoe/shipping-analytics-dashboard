class Request < ApplicationRecord
  attr_reader :message
  belongs_to :created_by
  belongs_to :user
  belongs_to :customer

  validates :created_by, presence: true

  def status(current_user)
    @request = self
    if @user == current_user
      owner_status_logic
    elsif @request.customer == current_user
      customer_status_logic
    end
  end

  private

  def owner_status_logic
    if @request.created_by == @request.proposal.shop.user
      # you make a proposal to a customer
      if @request.customer_confirmation
        @message = "#{@request.user.first_name} accepted your proposal!"
      elsif @request.customer_confirmation == false
        @message = "#{@request.user.first_name} declined your proposal."
      else
        @message = "You requested #{@request.user.full_name} to join #{@role.project.title}"
      end
    else
      # customer makes a proposal
      @message = "#{@request.customer.first_name} has made a proposal."
      @message = "You declined #{@request.customer.first_name}'s proposal." if @request.user_confirmation == false
    end
  end

  def customer_status_logic
    if @request.created_by == @request.customer
      # customer makes a proposal to a user
      @message = "You have made a request."
      @message = "#{@proposal.shop.user.first_name} declined your request." if @request.user_confirmation == false

    else
      # customer accepts or denies users proposal
      if @request.user_confirmation
        @message = "Your accepted the proposal."
      elsif @request.user_confirmation == false
        "You declined the proposal"
      else
        @message = "#{@proposal.shop.user.first_name} has made a proposal!"
      end
    end
  end
end
