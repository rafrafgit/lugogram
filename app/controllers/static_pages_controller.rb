class StaticPagesController < ApplicationController
  before_filter :signed_in_user

  def help
  end

end
