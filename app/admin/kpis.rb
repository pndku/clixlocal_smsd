ActiveAdmin.register Kpi do

  menu :priority => 1, :if => proc{ can?(:manage, Kpi) }
  controller.authorize_resource

  sidebar :actions, :only => :index do
    ul do
      li link_to "Import CSV", :action => :upload_csv
      li link_to "Truncate table", {:action => :truncate_table}, {:confirm => "Are you sure?"}
    end
  end

  collection_action :upload_csv, :method=>:get do
    render "admin/csv/upload_csv", :handler => :haml
  end

  collection_action :truncate_table, :method=>:get do
    if Kpi.delete_all
      flash[:notice] = "Table has been truncated successfully!"
    else
      flash[:notice] = "Table truncate failed!"
    end
    redirect_to :action => :index
  end

  collection_action :import_csv, :method=>:post do
    dump_file = (params.has_key?(:dump) && params[:dump].has_key?(:file)) ? params[:dump][:file] : nil
    if !dump_file.nil?
      CsvDb.import_csv("Kpi", dump_file, {:replace_with_key => "date"})
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
