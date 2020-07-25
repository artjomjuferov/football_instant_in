require_relative 'cookie_service'

class Auth
  CREDENTIALS_FILE = 'tmp/auth.json'

  def initialize(browser, logger)
    @browser = browser
    @logger = logger
    @email, @pass = load_credentials
    @cookie_service = CookieService.new(@browser)
  end

  def call
    @cookie_service.load_cookies

    if !@cookie_service.loaded_cookies? || logged_out?
      log_in
      @cookie_service.save_cookie
      @logger.info('Logged in and saved cookies')
    else
      @logger.info('Cookies alright')
    end
  end

  def log_in
    @browser.goto("https://facebook.com")

    email_input.focus.type(@email)
    pass_input.focus.type(@pass, :enter)

    sleep 3
  end

  def pass_input
    pass_input ||= @browser.at_xpath("//input[@id='pass']")
  end

  def email_input
    email_input ||= @browser.at_xpath("//input[@id='email']")
  end

  def logged_out?
    @browser.goto("https://www.facebook.com/groups/1722501571383616")
    sleep 2

    @browser.current_url != 'https://www.facebook.com/groups/1722501571383616'
  end

  def load_credentials
    file = File.open(CREDENTIALS_FILE)
    json = JSON.load(file).values
  end
end
