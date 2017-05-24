Puppet::Type.newtype(:bgp_neighbor) do
  @doc = %q{
    This type provides the capability to manage bgp neighbor within
    puppet.
  }

  ensurable do
    desc %q{ Manage the state of a neighbor }

    defaultto(:present)

    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end

    newvalue(:activate) do
      provider.activate
    end

    newvalue(:shutdown) do
      provider.shutdown
    end
  end

  newparam(:name) do
    desc %q{ A neighbor IP address or a peer-group name }

    block = /\d{,2}|1\d{2}|2[0-4]\d|25[0-5]/
    re = /\A#{block}\.#{block}\.#{block}\.#{block}\Z/

    newvalues(re)
    newvalues(/\A[\h:]\Z/)
    newvalues(/\A\w+\Z/)
  end

  newproperty(:allowas_in) do
    desc %q{ Accept as-path with my AS present in it }
    newvalues(/\A(10|[1-9])\Z/)

    munge do |value|
      value.to_i
    end
  end

  newproperty(:default_originate) do
    desc %q{ Originate default route to this neighbor }
    defaultto(:disabled)
    newvalues(:disabled, :enabled, :false, :true)

    munge do |value|
      case value
        when :false, 'false', false, 'disabled'
          :disabled
        when :true, 'true', true, 'enabled'
          :enabled
        else
          value
      end
    end
  end

  newproperty(:local_as) do
    desc %q{ Specify a local-as number }
    newvalues(/\A\d+\Z/)

    validate do |value|
      if value.to_i < 1
        raise(ArgumentError, "Invalid value \"#{value}\", valid values are 1-4294967295")
      end
    end

    munge do |value|
      value.to_i
    end
  end

  newproperty(:peer_group) do
    desc %q{ Member of the peer-group. }
    newvalues(:disabled, :enabled, :false, :true)
    newvalues(/\A[[:alpha:]]\w+\Z/)
    munge do |value|
      case value
        when :true, 'true', true, 'enabled'
          :enabled
        when :false, 'false', false, 'disabled'
          :disabled
        when String
          value.to_sym
        else
          value
      end
    end
  end

  newproperty(:prefix_list_in) do
    desc %q{ Filter updates from this neighbor }
    newvalues(/\A[[:alpha:]][\w-]+\Z/)
  end

  newproperty(:prefix_list_out) do
    desc %q{ Filter updates to this neighbor }
    newvalues(/\A[[:alpha:]][\w-]+\Z/)
  end

  newproperty(:remote_as) do
    desc %q{ Specify a BGP neighbor as }
    newvalues(/\A\d+\Z/)

    validate do |value|
      if value.to_i < 1
        raise(ArgumentError, "Invalid value \"#{value}\", valid values are 1-4294967295")
      end
    end

    munge do |value|
      value.to_i
    end
  end

  newproperty(:route_map_export) do
    desc %q{ Apply map to routes coming from a Route-Server client }
    newvalues(/\A[[:alpha:]][\w-]+\Z/)
  end

  newproperty(:route_map_import) do
    desc %q{ Apply map to routes going into a Route-Server client's table }
    newvalues(/\A[[:alpha:]][\w-]+\Z/)
  end

  newproperty(:route_map_in) do
    desc %q{ Apply map to incoming routes }
    newvalues(/\A[[:alpha:]][\w-]+\Z/)
  end

  newproperty(:route_map_out) do
    desc %q{ Apply map to outbound routes }
    newvalues(/\A[[:alpha:]][\w-]+\Z/)
  end
end