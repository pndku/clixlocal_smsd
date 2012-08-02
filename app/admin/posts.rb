ActiveAdmin.register Post do

  menu :priority => 2

  sidebar :actions, :only => :index do
    button_to "Import CSV", :action => :upload_csv
  end

  collection_action :upload_csv, :method=>:post do
    render "admin/csv/upload_csv", :handler => :haml
  end

  collection_action :import_csv, :method=>:post do
    dump_file = (params.has_key?(:dump) && params[:dump].has_key?(:file)) ? params[:dump][:file] : nil
    if !dump_file.nil?
      CsvDb.import_csv("Post", dump_file)
      flash[:notice] = "CSV imported successfully!"
      redirect_to :action => :index
    else
      flash[:notice] = "CSV import failed!"
      redirect_to :action => :upload_csv
    end
  end

  index do
    column "External article ID", :article_id
    column :headline
    column :author
    column :publish_date
    default_actions
  end

  form :html => { :multipart => true } do |f|
    f.inputs "Common information" do
      f.input :article_id, :label => "External article ID"
      f.input :headline
      f.input :author
      f.input :content
    end
    f.inputs "Source" do
      f.input :article_url
      f.input :media_provider
      f.input :media_provider
      f.input :publish_date
    end
    f.inputs "Statistics" do
      f.input :blog_post_sentiment
      f.input :signal_tag_sentiment
    end
    f.inputs "Priority" do
      f.input :priority
    end
    f.buttons
  end

end
