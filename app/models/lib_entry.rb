class LibEntry < ApplicationRecord
	belongs_to :lib_entry, :inverse_of => :lib_entries
	has_many :lib_entries, :inverse_of => :lib_entry, dependent: :destroy

	before_save :check_for_too_nested

# http://stackoverflow.com/questions/23837573/rails-4-how-to-cancel-save-on-a-before-save-callback
	def check_for_too_nested
		if lib_entry && lib_entry.try(:lib_entry)
			errors.add(:base, "Нельзя создать правовую статью с уровнем вложенности больше 2 (считая с 0).")
			throw :abort
		end
	end

	mount_uploader :file, FileUploader

	after_destroy :local_remove_file_directory

	def local_remove_file_directory

		remove_file_directory file

	end

  def uploader_name

    uploader_name_helper self

  end
  	
end