module ApplicationHelper
  def current_action
    "params[:controller]##{params[:action]}"
  end

  def current_action?(*actions)
    actions.each do |action|
      return true if action == current_action
    end
    false
  end
end
