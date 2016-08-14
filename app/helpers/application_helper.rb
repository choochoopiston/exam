module ApplicationHelper
  
  require 'RMagick'
    
  def profile_img(user)
    return image_tag(user.avatar, alt: user.name) if user.avatar?
    
    unless user.provider.blank?
      img_url = user.image_url
    else
      img_url = 'no_image.png'
    end
    image_tag(img_url, alt: user.name)
  end
  
  def profile_img_height(user, height)
    return image_tag(user.avatar, alt: user.name, title: user.name, :height => "#{height.to_i}") if user.avatar?
    
    unless user.provider.blank?
      img_url = user.image_url
    else
      img_url = 'no_image.png'
    end
    image_tag(img_url, :height => "#{height.to_i}", alt: user.name, title: user.name)
  end
  
  def profile_img_width(user, width)
    return image_tag(user.avatar, alt: user.name, :width => "#{width.to_i}") if user.avatar?
    
    unless user.provider.blank?
      img_url = user.image_url
    else
      img_url = 'no_image.png'
    end
    image_tag(img_url, :width => "#{width.to_i}", alt: user.name)
  end
  
  def profile_img_url(user)
    return user.avatar if user.avatar?
    
    unless user.provider.blank?
      img_url = user.image_url
    else
      img_url = 'no_image.png'
    end
    img_url
  end
  
  
  def profile_img_width_right(user, width)
    return image_tag(user.avatar, alt: user.name, :width => "#{width.to_i}", :class => "pull-right", :style => "vertical-align: middle;") if user.avatar?
    
    unless user.provider.blank?
      img_url = user.image_url
    else
      img_url = 'no_image.png'
    end
    image_tag(img_url, :width => "#{width.to_i}",  :class => "pull-right", :style => "vertical-align: middle;", alt: user.name)
  end
  
  def profile_img_ratio(user, a, b)
    return image_tag(user.avatar, alt: user.name, :size => "#{a.to_i}x#{b.to_i}") if user.avatar?
    
    unless user.provider.blank?
      img_url = user.image_url
    else
      img_url = 'no_image.png'
    end
    image_tag(img_url, :size => "#{a.to_i}x#{b.to_i}", alt: user.name, :class => "img-responsive")
  end
  
end
