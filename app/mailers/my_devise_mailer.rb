# https://github.com/plataformatec/devise/wiki/How-To:-Use-custom-mailer

class MyDeviseMailer < Devise::Mailer
  # include Roadie::Rails::Automatic

  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views

  # def confirmation_instructions(record, token, opts={})
  #   # attachments.inline['0.jpg'] = File.read(image_path("0.jpg"))
  #   attachments.inline['0.jpg'] = File.read("app/assets/images/logo_small.jpg")
  #   super
  # end

end