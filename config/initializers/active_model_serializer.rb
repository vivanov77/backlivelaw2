# Be sure to restart your server when you modify this file.

ActiveModelSerializers.config.adapter = :json_api

ActiveModel::Serializer.config.default_includes = '**' # (default '*')

ActiveModel::Serializer.config.key_transform = :unaltered