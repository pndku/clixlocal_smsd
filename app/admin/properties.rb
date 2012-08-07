ActiveAdmin.register Property do

  menu :priority => 3, :if => proc{ can?(:manage, Property) }
  controller.authorize_resource

end
