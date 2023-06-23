class Public::ConfigCreatorsController < ApplicationController

  def download_hara
    download_file_name = "public/master/IMG_0923.jpg"
    send_file download_file_name
  end

  def download_yaruki
    download_file_name = "public/master/IMG_0924.jpg"
    send_file download_file_name
  end

end
