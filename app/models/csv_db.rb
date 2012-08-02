require 'csv'

class CsvDb
  class << self
    def import_csv(model_name, csv_data, options={})

      csv_file = csv_data.read
      attributes = [];

      CSV.parse(csv_file) do |row|
        if attributes.empty?
          attributes = row
        else
          target_model = model_name.constantize
          new_object = target_model.new

          attributes.each do |attribute|
            if new_object.attributes.has_key? attribute
              value = row[attributes.find_index attribute]
              new_object.send "#{attribute}=", value
            end
          end

          if options.has_key?("default_attrs") and options.default_attrs.kind_of?(Array)
            options.default_attrs.each_pair do |attribute, value|
              if new_object.attributes.has_key? attribute
                new_object.send "#{attribute}=", value
              end
            end
          end

          new_object.save
        end
      end
    end
  end
end