ActiveAdmin.register Status do

  menu :priority => 3, :if => proc{ can?(:manage, Status) }
  controller.authorize_resource

  index do
    column :content
    column :created_at
  end


end
