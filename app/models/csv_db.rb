require 'csv'

class CSVDB

  class << self
    def import_csv(model_name, csv_data)
      csv_file = csv_data.read
      CSV.parse(csv_file) do |row|
        row
        target_model = model_name.classify.constantize
        new_object = target_model.new
        column_iterator = -1
        target_model.column_names.each do |key|
          if key != "ID" && key != "id"
            column_iterator += 1
            value = row[column_iterator]
            new_object.send "#{key}=", value
          end
        end
        new_object.save
      end
    end
  end

end