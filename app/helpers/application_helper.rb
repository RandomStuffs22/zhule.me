# coding: utf-8
module ApplicationHelper
  def message_link_tag(user, opts = {}, &block)
    return '' unless logged_in? 
    options = { :class => 'sendMsgBtn', :link_text => '', :title => "向#{user.login}发送私信", :rel => 'tipsy' }.merge(opts)
    link_text = options.delete(:link_text)
    options.merge!({ 'data-user_id' => user.id, 'data-user_name' => user.login })
    options[:class] << ' sendMsgBtn' unless options[:class].include?('sendMsgBtn')
    link_to 'javascript:;', options do
      if block_given?
        yield
      else
        "<i class='icons icons_mail'></i>#{link_text}".html_safe
      end
    end
  end

  def user_hearts_tag(user)
    helps_count = user.helped_stuffs_count
    helpfuls_count = user.assistance_helpers.helpful_assistance.count
    icons_tag = "<i class='icons icons_heart'></i>"

    if helpfuls_count <= 5
      if helps_count > 0
        total = icons_tag
      else
        total = "<span>还没有帮过任何人呢...</span>"
      end
    elsif helpfuls_count > 5 && helpfuls_count <= 15
      total = icons_tag * 2
    elsif helpfuls_count > 15 && helpfuls_count <= 25
      total = icons_tag * 3
    elsif helpfuls_count > 25 && helpfuls_count <= 35
      total = icons_tag * 4
    elsif helpfuls_count > 35
      total = icons_tag * 5
    end

    total.html_safe
  end

  def open_page_tag(user)
    open_page = ''
    if user.open_page.blank?
      if user.weibo_uid.present?
        weibo_url = "http://weibo.com/u/#{user.weibo_uid}"
        open_page = link_to weibo_url, weibo_url, :target => '_blank'
      end
    else
      if user.open_page.start_with?('http://') || user.open_page.start_with?('https://')
        open_page = link_to user.open_page, user.open_page, :target => '_blank'
      else
        url = 'http://' << user.open_page
        open_page = link_to url, url, :target => '_blank'
      end
    end
    open_page.html_safe
  end

  def render_page_title
    title = @page_title ? "#{@page_title} | #{SITE_NAME}" : SITE_NAME rescue "SITE_NAME"
    content_tag("title", title, nil, false)
  end  

end
