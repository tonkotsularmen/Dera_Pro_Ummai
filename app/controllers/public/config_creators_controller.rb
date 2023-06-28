class Public::ConfigCreatorsController < ApplicationController
  
  # ダウンロード機能,食欲がやばい画像
  def download_hara
    download_file_name = "public/master/IMG_0923.jpg"
    send_file download_file_name
  end
  
  # ダウンロード機能,やりたくなーい画像
  def download_yaruki
    download_file_name = "public/master/IMG_0924.jpg"
    send_file download_file_name
  end

end
