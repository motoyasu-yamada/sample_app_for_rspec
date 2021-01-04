RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium, using: :headless_chrome, options: { args: ["headless", "disable-gpu", "no-sandbox", "disable-dev-shm-usage"] }
    # driven_by :selenium, using: :headless_chrome, screen_size: [1920, 1080]
    # driven_by :selenium, using: :chrome, screen_size: [1080, 1080] # ローカルでの確認用
  end
end
