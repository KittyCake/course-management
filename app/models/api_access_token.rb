class ApiAccessToken < ApplicationRecord
  belongs_to :user

  before_create :generate_keys

  private

  def generate_keys
    # 確認 api access token 被建立後會建立一個隨機的密鑰
    # 會建立直到沒有重複的 key 為止
    begin
      self.key = SecureRandom.urlsafe_base64(30).tr('_-', 'xx')
    end while ApiAccessToken.where(key: key).any?
  end
end
