module Strftime
  def time_format
    created_at.strftime("%m/%d/%y at %l:%M %p")
  end
end