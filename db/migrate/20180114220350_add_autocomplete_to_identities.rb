class AddAutocompleteToIdentities < ActiveRecord::Migration[5.0]
  def change
    add_column :identities, :autocomplete, :string
  end
end
