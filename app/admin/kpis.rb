ActiveAdmin.register Kpis do

  menu :priority => 1, :label => "KPIS`es"

  sidebar :actions, :only => :index do
    button_to "Import CSV", :action => :upload_csv
  end

  collection_action :upload_csv, :method=>:post do
    render "admin/csv/upload_csv", :handler => :haml
  end

  collection_action :import_csv, :method=>:post do
    dump_file = (params.has_key?(:dump) && params[:dump].has_key?(:file)) ? params[:dump][:file] : nil
    if !dump_file.nil?
      CsvDb.import_csv("Kpis", dump_file)
      flash[:notice] = "CSV imported successfully!"
      redirect_to :action => :index
    else
      flash[:notice] = "CSV import failed!"
      redirect_to :action => :upload_csv
    end
  end

  index do
    column :date
    column :petition_signatures
    column :petition_recommendations
    default_actions
  end

end
