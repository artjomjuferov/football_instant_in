require 'json'

class CookieService
  COOKIES_FILE = 'tmp/cookie.json'
  ATTRIBUTES = %i[name value domain path expires size httponly? secure? session? samesite]

  def initialize(browser)
    @browser = browser
  end

  def load_cookies
    file = File.open(COOKIES_FILE)
    json = JSON.load(file)
    if json
      @browser.cookies.set(json.transform_keys(&:to_sym))
      @load_cookies = true
    else
      @load_cookies = false
    end
    file.close
  rescue Errno::ENOENT
    @load_cookies = false
  end

  def loaded_cookies?
    @load_cookies || false
  end

  def save_cookie
    ferrum_cookie = @browser.cookies.all.first&.[](1)
    return unless ferrum_cookie

    File.open(COOKIES_FILE,"w") do |f|
      f.write(json_for_save(ferrum_cookie).to_json)
    end
  end

  private

  def json_for_save(ferrum_cookie)
    ATTRIBUTES.each_with_object({}) do |attr, res|
      res[attr] = ferrum_cookie.public_send(attr)
      res[attr] = res[attr].to_f if attr == :expires
    end.merge(priority: 'medium') # TODO: fix it
  end
end
