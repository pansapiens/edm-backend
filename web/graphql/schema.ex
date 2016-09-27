defmodule EdmBackend.GraphQL.Schema do
  require Logger
  use Absinthe.Schema
  use Absinthe.Relay.Schema
  alias EdmBackend.GraphQL.Resolver
  alias EdmBackend.Client

  import_types EdmBackend.GraphQL.Types

  query do

    @desc "Lists all clients"
    connection field :clients, node_type: :client do
      resolve fn
        pagination_args, _ ->
          Resolver.Client.list(pagination_args)
      end
    end

    @desc "Shows information about the currently logged in client"
    field :current_client, :client do
      resolve fn
        _, %{context: %{current_resource: %Client{} = current_client}} ->
          Resolver.Client.find(%{id: current_client.id})
        _, _ ->
          {:error, "Not logged in"}
      end
    end

    node field do
      resolve fn
        %{type: :client, id: id}, _ ->
          Resolver.Client.find(%{id: id})
        %{type: :group, id: id}, _ ->
          Resolver.Group.find(%{id: id})
        %{type: :credential, id: id}, _ ->
          Resolver.Credential.find(%{id: id})
      end
    end

  end

  mutation do
    payload field :create_client do
      input do
        field :uuid, non_null(:string)
      end
      output do
        field :token, :string
      end
      resolve fn
        %{input_data: input_data}, _ ->
          # Some mutation side-effect here
          {:ok, %{result: input_data * 2}}
      end
    end
  end

end
