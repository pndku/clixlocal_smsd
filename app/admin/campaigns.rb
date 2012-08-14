ActiveAdmin.register Campaign do

  menu :priority => 5, :if => proc{ can?(:manage, Campaign) }
  controller.authorize_resource

  index do
    column :name
    column :keywords
    default_actions
  end


end
