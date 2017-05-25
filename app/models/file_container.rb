class FileContainer < ApplicationRecord
	mount_uploader :file, FileUploader

	belongs_to :fileable, polymorphic: true

	after_destroy :local_remove_file_directory

	def local_remove_file_directory

		remove_file_directory file

	end
 	
end