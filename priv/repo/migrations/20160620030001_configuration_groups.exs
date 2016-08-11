defmodule EdmBackend.Repo.Migrations.ConfigurationGroups do
  use Ecto.Migration

  def change do
    create table(:configuration_groups) do
      add :name, :string, size: 255
      add :description, :string, size: 255
      add :configuration_blob, :string, size: 4000
      add :facility_id, references(:facilities)
      timestamps
    end
    create unique_index(:configuration_groups, [:name, :facility_id])
  end
end
