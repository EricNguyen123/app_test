# frozen_string_literal: true

# daily report
class DailyReportJob
  include Sidekiq::Worker

  def perform
    client = Slack::Web::Client.new
    client.chat_postMessage(channel: '#general', text: report_message)
  end

  def report_message
    new_users = User.user_yesterday.count
    new_posts = Micropost.microposts_yesterday.count
    new_comments = Micropost.all_micropost_yesterday.count - new_posts
    microposts = most_commented_post
    <<~REPORT
    Daily report:
      - Number of newly registered users: #{new_users}
      - Number of new posts: #{new_posts}
      - Number of new comments: #{new_comments}
      - Most commented post: #{microposts&.map { |micropost| "[#{micropost.content}], (#{ENV['HOST']}/microposts/#{micropost.id}) " }}
    REPORT
  end

  def most_commented_post
    microposts = Micropost.microposts_yesterday
    max_count = 0
    micropost_cmt_max = []
    microposts.each do |micropost|
      res = count_commented_posts(micropost, 0)
      micropost_cmt_max << micropost if max_count == res
      if max_count < res
        max_count = res
        micropost_cmt_max = [micropost]
      end
    end
    micropost_cmt_max
  end

  def count_commented_posts(micropost, counts)
    comments = Micropost.where(micropost_id: micropost.id)
    unless comments.empty?
      comments.each do |comment|
        counts += count_commented_posts(comment, counts)
      end
      counts += comments.count
    end
    counts
  end
end
