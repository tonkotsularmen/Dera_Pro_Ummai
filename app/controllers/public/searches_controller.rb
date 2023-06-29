class Public::SearchesController < ApplicationController
  include Common
  before_action :authenticate_user!

end
