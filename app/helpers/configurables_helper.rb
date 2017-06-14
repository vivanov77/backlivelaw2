module ConfigurablesHelper

  def init_configurable

  	# run "helper.init_configurable" in console to load it there

  	return if Configurable.respond_to? :get_all

    Configurable.instance_eval do
      def get_all   
        (Configurable.all.size > 0 ? Configurable.all : []) + 
        (Configurable.defaults.keys - Configurable.all.collect { |c| c.name })
      end

      # def get_part part
      #   # http://stackoverflow.com/questions/3794039/how-to-find-a-hash-key-containing-a-matching-value
      #   keys_part = (Configurable.defaults.select{|key, hash| hash[:part] == part }).keys
      #   db_part = Configurable.all.where(name: keys_part)

      #   (db_part.size > 0 ? db_part : []) + 
      #   (keys_part - db_part.collect { |c| c.name })
      # end

      # def get_all_minus_part part
      #   # http://stackoverflow.com/questions/3794039/how-to-find-a-hash-key-containing-a-matching-value
      #   keys_part = (Configurable.defaults.select{|key, hash| hash[:part] != part }).keys
      #   db_part = Configurable.all.where.not(name: keys_part)

      #   (db_part.size > 0 ? db_part : []) + 
      #   (keys_part - db_part.collect { |c| c.name })
      # end      

      def found name
      	c = Configurable.find_by(name: name)

        if c && (c.type_image? || c.type_file?)

          c

        else

        	res = c && !c.value.blank?
        	res ? c : nil

        end
      end

      def found_csubtypes name, csubtype
      	c = self.found name
      	return nil unless c

    		value_hash = JSON.parse c.value
    		csubtype_list = value_hash.collect {|e| e[csubtype.to_s].keys[0]}
    		csubtype_list.delete("")

    		csubtype_list.join.blank? ? nil : csubtype_list

      end

      # mount_uploader :file, FileUploader

      mount_uploader :chat_sound_free, FileUploader

      mount_uploader :chat_sound_paid, FileUploader

    end

    # http://stackoverflow.com/questions/5654517/in-ruby-on-rails-to-extend-the-string-class-where-should-the-code-be-put-in
    Configurable.class_eval do

      def ctyped?
    # http://stackoverflow.com/questions/22649548/ruby-how-to-check-if-a-hash-key-exists    
        Configurable.defaults[self.name].has_key? :ctype
      end      

      def title
        Configurable.defaults[self.name][:name]
      end

      def norm_title
        Configurable.defaults[self.name][:name].chomp(" (Обувь)")
      end      

      def part
        Configurable.defaults[self.name][:part]
      end      

      def ctype_titles
        Configurable.defaults[self.name][:ctype].values
      end

      def ctype_values ctype_name

        self.get_ctable.map {|e| e[ctype_name.to_s].keys[0]}

      end

      def ctype_title name
        Configurable.defaults[self.name][:ctype][name]
      end      

      def ctype_names
      # http://stackoverflow.com/questions/16502866/how-to-convert-a-array-of-strings-to-an-array-of-symbols
        Configurable.defaults[self.name][:ctype].keys.map(&:to_sym)
      end

      def csubtyped?
    # http://stackoverflow.com/questions/22649548/ruby-how-to-check-if-a-hash-key-exists    
        Configurable.defaults[self.name].has_key? :csubtype
      end      

      def key_subtyped? key

        self.csubtyped? && (Configurable.defaults[self.name][:csubtype].has_key? key)

      end

      def subtypes_hash key

        Configurable.defaults[self.name][:csubtype][key]

      end

      def param2hash2 param
        # http://stackoverflow.com/questions/1667630/how-do-i-convert-a-string-object-into-a-hash-object
        # arr["1"]
        # http://stackoverflow.com/questions/800122/best-way-to-convert-strings-to-symbols-in-hash    
        JSON.parse(param.gsub('=>', ':')).symbolize_keys
      end

      def new_table_line

        chash = {}

        self.ctype_names.each do |name|

          eh = {}

          eh[nil] = nil

          chash[name.to_s] = eh

        end

        chash

      end


      def set_ctable ctype_hash, csubtype_hash

        if self.value.blank?

          res_array = []

        else

          res_array = JSON.parse self.value

        end

        # res_array = [{"phone"=>{""=>nil}, "email"=>{""=>nil}, "address"=>{""=>nil}}]

        # ctype_hash = {"phone"=>"123", "email"=>"", "address"=>""}

        # csubtype_hash = {"address"=>""}
        # csubtype_hash = {"address"=>"warehouse"}

        # ctype_names = [:phone, :email, :address]
# http://stackoverflow.com/questions/19148680/how-to-remove-hash-keys-which-hash-value-is-blank
        names = (ctype_hash.delete_if { |key, value| value.blank? }).keys

        names.each do |name|

          flag_csubtype = csubtype_hash && (csubtype_hash.has_key? name.to_s) && !csubtype_hash[name.to_s].blank?

          line_index_found = 0

          index_found = false

          res_array.each_with_index do |line, index| # line = {"phone"=>{""=>nil}, "email"=>{""=>nil}, "address"=>{""=>nil}}

            if line[name.to_s].keys[0].blank?

              line_index_found = index

              index_found = true

              break

            end

          end


          unless index_found

            res_array << new_table_line

            line_index_found = res_array.size-1

          end

          res_array[line_index_found][name.to_s] = Hash[ctype_hash[name.to_s], flag_csubtype ? csubtype_hash[name.to_s] : nil]

        end

        res_array.to_json

      end

      def get_ctable

        if self.value.blank?

          []

        else

          JSON.parse self.value

        end        

      end

      def subtype_title subtype_key, subtype_subkey

        if self.key_subtyped? subtype_key

          Configurable.defaults[self.name][:csubtype][subtype_key.to_s][subtype_subkey.to_s]

        else

          nil

        end
        
      end

      def destroy_ctable_value row_index, name

        res_array = self.get_ctable

        eh = {}

        eh[nil] = nil

        res_array[row_index][name.to_s] = eh

        for rindex in row_index..res_array.size-2

           res_array[rindex][name.to_s] = res_array[rindex+1][name.to_s]

           res_array[rindex+1][name.to_s] = eh

        end

        if (res_array[res_array.size-1].values.collect {|e| e.keys[0]}).join.blank?

          res_array.delete_at (res_array.size-1)

        end

        res_array.to_json

      end

      def type_text?

      	Configurable.defaults[self.name][:type] == "text"

      end

      def type_string?

      	Configurable.defaults[self.name][:type] == "string"

      end

      def type_image?

        Configurable.defaults[self.name][:type] == "image"

      end

      def type_file?

        Configurable.defaults[self.name][:type] == "file"

      end

      def uploader_name

        uploader_name_helper self

      end      

    end

  end


end
