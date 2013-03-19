ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => 'clinic', :action => 'index'
  map.create '/create', :controller => 'encounters', :action => 'create'

  map.user_login '/user_login/:id', :controller => 'clinic', :action => 'user_login'

  map.user_logout '/user_logout/:id', :controller => 'clinic', :action => 'user_logout'

  map.set_datetime '/set_datetime', :controller => 'clinic', :action => 'set_datetime'

  map.update_datetime '/update_datetime', :controller => 'clinic', :action => 'update_datetime'

  map.reset_datetime '/reset_datetime', :controller => 'clinic', :action => 'reset_datetime'

  map.overview '/overview', :controller => 'clinic', :action => 'overview'

  map.reports '/reports', :controller => 'clinic', :action => 'reports'

  map.my_account '/my_account', :controller => 'clinic', :action => 'my_account'

  map.administration '/administration', :controller => 'clinic', :action => 'administration'

  map.project_users '/project_users', :controller => 'clinic', :action => 'project_users'

  map.project_users_list '/project_users_list', :controller => 'clinic', :action => 'project_users_list'

  map.add_to_project '/add_to_project', :controller => 'clinic', :action => 'add_to_project'

  map.remove_from_project '/remove_from_project', :controller => 'clinic', :action => 'remove_from_project'

  map.manage_activities '/manage_activities', :controller => 'clinic', :action => 'manage_activities'

  map.check_role_activities '/check_role_activities', :controller => 'clinic', :action => 'check_role_activities'

  map.create_role_activities '/create_role_activities', :controller => 'clinic', :action => 'create_role_activities'

  map.remove_role_activities '/remove_role_activities', :controller => 'clinic', :action => 'remove_role_activities'

  map.project_members '/project_members', :controller => 'clinic', :action => 'project_members'

  map.my_activities '/my_activities', :controller => 'clinic', :action => 'my_activities'

  map.check_user_activities '/check_user_activities', :controller => 'clinic', :action => 'check_user_activities'

  map.create_user_activity '/create_user_activity', :controller => 'clinic', :action => 'create_user_activity'

  map.remove_user_activity '/remove_user_activity', :controller => 'clinic', :action => 'remove_user_activity'

  map.list_observations '/list_observations', :controller => 'encounters', :action => 'list_observations'

  map.void '/void', :controller => 'encounters', :action => 'void'

  map.list_encounters '/list_encounters', :controller => 'encounters', :action => 'list_encounters'

  map.demographics_fields '/demographics_fields', :controller => 'clinic', :action => 'demographics_fields'

  map.show_selected_fields '/show_selected_fields', :controller => 'clinic', :action => 'show_selected_fields'

  map.remove_field '/remove_field', :controller => 'clinic', :action => 'remove_field'

  map.add_field '/add_field', :controller => 'clinic', :action => 'add_field'

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
