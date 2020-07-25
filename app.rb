require 'ferrum'
require 'byebug'
require 'logger'
require 'fileutils'
require_relative 'services/auth'
require_relative 'services/visit_post_if_exists'
require_relative 'services/leave_plus_comment'
require_relative 'services/post_analyzer'
require_relative 'services/proper_thursday'

class App
  def initialize
    @browser = Ferrum::Browser.new
    FileUtils.mkdir_p log_dir
    @logger = Logger.new("#{log_dir}/#{Time.now.to_i}.log")
  end

  def call
    Auth.new(@browser, @logger).call
    @logger.info('Authenticated')

    if VisitPostIfExists.new(@browser).call
      @logger.info("Post found #{@browser.current_url}")
      LeavePlusComment.new(@browser).call
      @logger.info('Comment left')
    else
      @logger.info('Post is not published yet')
    end
  end

  private

  def log_dir
    @log_dir ||= "logs/#{ProperThursday.new.call}"
  end
end
