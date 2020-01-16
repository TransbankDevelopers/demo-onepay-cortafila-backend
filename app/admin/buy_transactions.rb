ActiveAdmin.register BuyTransaction do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :status, :response_code, :description, :occ, :authorizationCode, :issuedAt, :signature, :amount, :transactionDesc, :installmentsAmount, :installmentsNumber, :buyOrder, :ShoppingCart_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:status, :response_code, :description, :occ, :authorizationCode, :issuedAt, :signature, :amount, :transactionDesc, :installmentsAmount, :installmentsNumber, :buyOrder, :ShoppingCart_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  actions :index, :show
  filter :status
  filter :issuedAt
  filter :response_code
  filter :amount
  filter :occ

end
