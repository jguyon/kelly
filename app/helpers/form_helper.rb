module FormHelper
  class BetterFormBuilder < ActionView::Helpers::FormBuilder
    def error_notification
      if @object.errors.any?
        @template.content_tag :p, class: 'red-text' do
          @template.t 'helpers.error_notification'
        end
      end
    end

    %w{ check_box color_field date_field datetime_field datetime_local_field
    email_field file_field month_field number_field password_field phone_field
    radio_button range_field search_field telephone_field text_area text_field
    time_field url_field week_field }.each do |field|
      define_method field do |method, options = {}|
        if @object.errors[method].any?
          options[:class] ||= ''
          options[:class] += ' invalid'
        end
        super method, options
      end
    end

    def label(method, options = {})
      if @object.errors[method].any?
        options[:class] ||= ''
        options[:class] += ' red-text'
        super method, @object.errors.full_messages_for(method).first, options
      else
        super method
      end
    end
  end

  def better_form_for(object, options = {}, &block)
    form_for object, options.merge(builder: BetterFormBuilder), &block
  end
end
