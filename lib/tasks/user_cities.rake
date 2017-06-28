
namespace :kladr do

  desc 'Загрузить города в пользователей.'
  task user_cities: :environment do
    generate_models
  end  

  def generate_models

    user2 = User.find 2
    user2.cities.clear
    user2.cities << (City.find_by name: "Ростов-на-Дону")
    user2.save!

    user3 = User.find 3
    user3.cities.clear    
    user3.cities << (City.find_by name: "Батайск")
    user3.save!

    user4 = User.find 4
    user4.cities.clear    
    user4.cities << (City.find_by name: "Зерноград")
    user4.save!

    user5 = User.find 5
    user5.cities.clear    
    user5.cities << (City.find_by name: "Каменск-Шахтинский")
    user5.save!

    user6 = User.find 6
    user6.cities.clear    
    user6.cities << (City.find_by name: "Новочеркасск")
    user6.save!

    user7 = User.find 7
    user7.cities.clear    
    user7.cities << (City.find_by name: "Шахты")
    user7.save!

 end

end