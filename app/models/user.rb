class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  # フォローする関連(能動)
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy # buildとかcreateなどuserに紐づいたものが使える
  has_many :following, through: :active_relationships, source: :followed # user.following でフォローしてるユーザー一覧を取得
  # フォローされる関連(受動)
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower # user.followers でフォローしてる

  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :down_case_email
  before_create :create_activation_digest
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

  # 渡されたトークンがダイジェストと一致したらtrueを返す (10.24で更新)
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # ユーザーログインを破棄
  def forget
    update_attribute(:remember_digest, nil)
  end

  # アカウントの有効化
  def activate
    self.update_attribute(:activated, true)
    self.update_attribute(:activated_at, Time.zone.now)
  end

  # 有効化用のメール送信
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # パスワード再設定のメール送信
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # パスワード再設定の期限が切れている場合はtrue
  def password_reset_expired?
    self.reset_sent_at < 2.hours.ago # ~はより早い時刻と読む。つまり、現在より２時間以上前ならtrueを返す
  end

  # feed(タイムライン)=自分と関係する投稿一覧
  def feed
    Micropost.where('user_id = ?', self.id)
  end

  # ユーザーをフォロー
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # アンフォローする
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrue
  def following?(other_user)
    following.include?(other_user)
  end

  private
    # メアドを全部小文字に
    def down_case_email
      self.email = self.email.downcase
    end

    # 有効かトークンとダイジェストを作成及び代入
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(self.activation_token) # 保存される前に属性値を持たせておく
    end
end
