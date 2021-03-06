ActiveAdmin.register Post do

  menu :priority => 2, :if => proc{ can?(:manage, Post) }
  controller.authorize_resource

  scope :all do |posts|
    posts.fresh
  end

  scope :important do |posts|
    posts.fresh.important
  end

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
    if Post.delete_all
      flash[:notice] = "Table has been truncated successfully!"
    else
      flash[:notice] = "Table truncate failed!"
    end
    redirect_to :action => :index
  end

  collection_action :import_csv, :method=>:post do
    dump_file = (params.has_key?(:dump) && params[:dump].has_key?(:file)) ? params[:dump][:file] : nil
    if !dump_file.nil?
      CsvDb.import_csv("Post", dump_file, {:replace_with_key => "article_id"})
      flash[:notice] = "CSV imported successfully!"
      redirect_to :action => :index
    else
      flash[:notice] = "CSV import failed!"
      redirect_to :action => :upload_csv
    end
  end

  index do
    column :publish_date
    column :media_provider
    column :author
    column :content
    default_actions
  end

  form :html => { :multipart => true } do |f|
    f.inputs "Common information" do
      f.input :article_id
      f.input :headline
      f.input :author
      f.input :content
    end
    f.inputs "Source" do
      f.input :article_url
      f.input :media_provider
      f.input :publish_date
    end
    f.inputs "Statistics" do
      f.input :blog_post_sentiment
      f.input :signal_tag_sentiment
    end
    f.inputs "Importance" do
      f.input :important
    end
    f.buttons
  end

  show do |f|
    attributes_table do
      row :id
      row :article_id
      row :headline
      row :author
      row :content
      row :article_url
      row :media_provider
      row :publish_date
      row :blog_post_sentiment
      row :signal_tag_sentiment
      row :important
    end
    active_admin_comments
  end

end
