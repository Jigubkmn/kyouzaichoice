class TopController < ApplicationController
  skip_before_action :require_login, only: %i[index term_of_service privacy_policy inquiry]

  def index; end

  def term_of_service; end

  def privacy_policy; end

end
