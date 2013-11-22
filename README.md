## Cloud Foundry Services API v2 Spook

This app creates a 'faux' Clound Foundry Service for use in your Bosh Lite
deployment. This way you can develop CloudController API tools without needing
a 'real' service provider.

## Based on

This work based on the [fake_service_broker.rb](https://github.com/cloudfoundry/cloud_controller_ng/blob/master/spec/support/integration/fake_service_broker.rb#L4)
integration helper found in [CloudControllerNG](https://github.com/cloudfoundry/cloud_controller_ng)

## To install..

Assuming you are using [The Go CloudFoundry CLI](https://github.com/cloudfoundry/cli)

    git clone https://github.com/pivotal-grapevine/cf-v2-spook.git
    cd cf-v2-spook
    cf push spook
    cf create-service-broker spook i_love_rabbits my_spook_pass http://spook.10.244.0.34.xip.io
