
namespace :uploads do

  desc 'Очистить пустые папки из-под файловых вложений.'
  task clear: :environment do
    delete_empty_folders
  end  

  def delete_empty_folders

# http://stackoverflow.com/questions/1290670/ruby-how-do-i-recursively-find-and-remove-empty-directories    

    dir = (Rails.root + "public/uploads/file_container/file").to_s

    Dir["#{dir.to_s}/**/"].reverse_each { |d| Dir.rmdir d if Dir.entries(d).size == 2 }

  end
end