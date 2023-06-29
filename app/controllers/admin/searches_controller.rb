class Admin::SearchesController < ApplicationController
  include Common
  before_action :authenticate_admin!

end
