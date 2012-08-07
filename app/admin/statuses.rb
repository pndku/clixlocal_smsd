ActiveAdmin.register Status do

  menu :priority => 99, :if => proc{ can?(:manage, Status) }
  controller.authorize_resource

  index do
    column :content
    column :created_at
  end


end
