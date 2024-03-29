RailsAdmin.config do |config|
  config.asset_source = :importmap

  ### Popular gems integration

  config.model 'Order' do
    edit do
      field :refund_confirmed do
        visible do
          bindings[:object].order_status == 5
        end
      end
      field :order_status, :enum do
        enum do
          {
            'pending': 0,
            '1': 1,
            '2': 2,
            '3': 3,
            '4': 4,
            '5': 5,
            '6': 6
          }
        end
      end
    end
  end
  

  config.model 'Order' do
    list do
      field :created_at do
        filterable :date_range # Add the date range filter
      end
    end
  end

  ## == Devise ==
  config.authorize_with do
    unless current_user && current_user.admin?
      flash[:error] = "You are not authorized to access this page."
      redirect_to main_app.root_path
    end
  end

  config.navigation_static_links = {
    'Chart' => '/chart'
  }
  
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/railsadminteam/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
