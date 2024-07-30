module ApplicationHelper
  def flash_background_color(type)
    case type.to_sym
    when :success  then "bg-flash-messages-green"
    when :danger   then "bg-flash-messages-red"
    when :error  then "bg-flash-messages-yellow"
    else "bg-gray-500"
    end
  end
end
