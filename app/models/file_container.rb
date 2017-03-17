class FileContainer < ApplicationRecord
	mount_uploader :file, FileUploader

	belongs_to :fileable, polymorphic: true

	after_destroy :remove_file_directory

# http://stackoverflow.com/questions/7994484/empty-folders-when-file-is-deleted-using-carrierwave
	def remove_file_directory
		path = File.expand_path(file.store_path, file.root)
		FileUtils.remove_dir(path, force: false)
	end
 	
end