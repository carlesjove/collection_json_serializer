module CollectionJson
  module Spec
    DEFINITION = {
      href: {},
      links: {
        href: { required: true },
        rel: {},
        name: {},
        prompt: {},
        render: {}
      },
      items: {
        href: {},
        data: {
          name: {},
          value: {},
          prompt: {}
        },
        links: {
          href: {},
          rel: {},
          name: {},
          prompt: {},
          remder: {}
        }
      },
      template: {
        data: {
          name: {},
          value: {},
          prompt: {}
        }
      },
      queries: {
        href: { required: true },
        rel: {},
        name: {},
        prompt: {},
        data: {
          name: {},
          value: {}
        }
      },
      error: {
        title: {},
        code: {},
        message: {}
      }
    }
  end
end

