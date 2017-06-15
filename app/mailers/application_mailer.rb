class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.secrets.YANDEX_LOGIN

  layout 'mailer'
end
