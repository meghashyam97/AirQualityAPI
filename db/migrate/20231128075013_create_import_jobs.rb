class CreateImportJobs < ActiveRecord::Migration[7.1]
  def change
    create_table :import_jobs do |t|
      t.string :job_type
      t.string :status
      t.integer :retry_count
      t.string :error_message
      t.text :logs
      t.string :job_id
      t.timestamps
    end
  end
end
