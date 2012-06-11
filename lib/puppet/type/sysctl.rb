module Puppet
  newtype(:sysctl) do

    @doc = "Manages sysctl volues. This module will ensure the value of
      kernel settings in the sysctl configuration. It can also remove
      values so that they fall back on the system defaults. This module
      will optionally ensure that the value specified is the current 
      running value in the system. Naturally, this is not always a great
      idea. 

      As a general warning, please be aware you're messing with internal 
      settings of your kernel, possibly durring runtime!. It is not the 
      fault of this type if you use it to make poorly researched desicions."


    ensurable #do
    #   puts "#{self}"
    #   def retrieve
    #     self.fail("Cannot find kernel paramter on system.") if not provider.isparam?(resource[:name])
    #     super
    #   end
    # end

    # feature :changesysctl, "The provider needs to modify the running kernel paramter values.",
    #   :methods => [:sysctlparam?, :sysctlparam=]

    # newproperty(:activate, :required_features => :changesysctl) do
    #   desc "Set paramter of running system if it differs."

    #   newvalue (:yes)

    #   defaultto (:false)
    # end

    newparam(:name) do
      desc "Name of the kernel parameter."

      isnamevar

      validate do |value|
        unless value =~ /^[\w\d_\.\-]+$/ 
          raise ArgumentError, "Kernel parameter formatting is not valid."
        end
      end
    end

    newproperty(:val) do
      desc "Value of the kernel parameter."
    end

    #newproperty(:comment) do
    #  desc "A comment that will be placed above the line with a # character."
    #end

    newproperty(:target) do
      desc "The file in which to store sysctl information. Only used when 
        saving changes to disk. Defaults to `/etc/sysctl.conf`. Some newer
        distrobutions of Linux now support a `sysctl.d` directory."

      defaultto { 
        if @resource.class.defaultprovider.ancestors.include?(Puppet::Provider::ParsedFile)
          @resource.class.defaultprovider.default_target
        else
          nil
        end
      }
    end
    
    autorequire(:file) do
      ["/etc/sysctl.conf"]
    end
  end
end
