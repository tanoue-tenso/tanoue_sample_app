class User < ActiveRecord::Base
  attr_accessor :remember_token
  before_save { self.email = self.email.downcase }
  validates :name,
            presence: true,
            length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
            presence: true,
            length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false } # 大文字小文字の区別をしない

  has_secure_password
  validates :password,
            presence: true, # has_secure_passwordの存在性確認は「更新時」には適用してくれないので追記
            length: { minimum: 6 },
            allow_nil: true # 更新時に空欄を許可, 登録時は has_secure_password がやってくれる

  # 文字列のハッシュ値を返す
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # ハッシュ化させる前に、remember_tokenで仮想的に保存し、ハッシュ化したものをremember_digestに保存
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    # remember_digestカラムはハッシュ化した remember_token と一致しているか比較している
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーログインを破棄
  def forget
    update_attribute(:remember_digest, nil)
  end
end
