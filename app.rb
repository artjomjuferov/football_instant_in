require 'ferrum'
require 'byebug'
require_relative 'services/auth'
require_relative 'services/find_needed_post'
require_relative 'services/leave_plus_comment'
require_relative 'services/post_analyzer'

class App
  def initialize
    @browser = Ferrum::Browser.new
  end

  def call
    Auth.new(@browser).call

    @browser.screenshot(path: "tmp/auth.png")

    post = FindNeededPost.new(@browser).call

    LeavePlusComment.new(@browser).call if post
  end
end
