# Fix Odnoklassniki OAuth gem via
# https://github.com/incubus/omniauth-odnoklassniki/issues/10

# OmniAuth::Strategies::Odnoklassniki.class_eval do
#   def callback_url
#     options.redirect_url || (full_host + script_name + callback_path)
#   end
# end