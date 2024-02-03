class CreateTypeReferenceValues < ActiveRecord::Migration[6.1]
  def change
    create_table :type_reference_values do |t|
      t.references :result       , foreign_key: true 
      t.integer :type1_a           
      t.integer :type1_b           
      t.integer :type1_c           
      t.integer :type1_d           
      t.integer :type1_e           
      t.integer :type2_a           
      t.integer :type2_b           
      t.integer :type2_c           
      t.integer :type2_d           
      t.integer :type2_e           
      
    end
  end
end
