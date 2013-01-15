require 'fog/core/collection'
require 'fog/rackspace/models/compute_v2/server'

module Fog
  module Compute
    class RackspaceV2

      class Servers < Fog::Collection

        model Fog::Compute::RackspaceV2::Server

        def all
          data = service.list_servers.body['servers']
          load(data)
        end

        def bootstrap(new_attributes = {}, timeout=1500)
          server = create(new_attributes)
          server.wait_for(timeout) { ready? && !ipv4_address.empty? }
          server.setup(:password => server.password)
          server
        end

        def get(server_id)
          data = service.get_server(server_id).body['server']
          new(data)
        rescue Fog::Compute::RackspaceV2::NotFound
          nil
        end
      end
    end
  end
end
