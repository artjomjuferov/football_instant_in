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
      byebug
      set_cookies(json)
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
    ferrum_cookies = @browser.cookies.all
    return if ferrum_cookies.empty?

    File.open(COOKIES_FILE,"w") do |f|
      f.write(cookies_hash_to_save(ferrum_cookies).to_json)
    end
  end

  private

  def set_cookies(cookies_from_file)
    cookies_from_file.each do |_name, cookie|
      @browser.cookies.set(cookie.transform_keys(&:to_sym))
    end
  end

  def cookies_hash_to_save(ferrum_cookies)
    ferrum_cookies.each_with_object({}) do |(name, ferum_cookie), res|
      res[name] = parse_cookie(ferum_cookie)
    end
  end

  def parse_cookie(ferrum_cookie)
    ATTRIBUTES.each_with_object({}) do |attr, res|
      res[attr] = ferrum_cookie.public_send(attr)
      res[attr] = res[attr].to_f if attr == :expires
    end.merge(priority: 'medium') # TODO: fix it
  end
end
