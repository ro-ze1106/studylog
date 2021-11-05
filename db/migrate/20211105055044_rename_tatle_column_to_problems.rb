class RenameTatleColumnToProblems < ActiveRecord::Migration[6.1]
  def change
    rename_column :problems, :tatle, :title
  end
end
