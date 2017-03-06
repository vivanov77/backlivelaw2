
namespace :kladr do

  desc 'Загрузить модели регионов и городов из json-файла.'
  task seed: :environment do
    seed_models
  end  

  def seed_models

    include ApplicationHelper

    seed_regions

    seed_cities

    seed_ipranges

  end
end