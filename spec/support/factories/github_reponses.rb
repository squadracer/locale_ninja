# frozen_string_literal: true

module Factory
  class << self
    def branches_result
      [
        {
          name: 'main',
          commit:
          {
            sha: '48e1355f16ed52e1dd3cba94658a24c48c6f8208',
            url: 'https://api.github.com/repos/squadracer/locale-ninja-test/commits/48e1355f16ed52e1dd3cba94658a24c48c6f8208'
          },
          protected: false
        },
        {
          name: 'develop',
          commit:
         {
           sha: '2bff80bba997dad96eb0146ec69a0b524836f3f7',
           url: 'https://api.github.com/repos/squadracer/locale-ninja-test/commits/2bff80bba997dad96eb0146ec69a0b524836f3f7'
         }
        }, {
          name: 'main__translations',
          commit:
          {
            sha: '48e1355f16e522e1dd3cba94658a24c48c6f8208',
            url: 'https://api.github.com/repos/squadracer/locale-ninja-test/commits/48e1355f16e522e1dd3cba94658a24c48c6f8208'
          },
          protected: false
        }
      ].to_json
    end

    def recursive_tree_result
      {
        tree: [
          {
            path: 'config/locales/it/it.yml',
            mode: '100644',
            type: 'blob',
            sha: 'e9101db78943e1f2916e29f5b5bf49715600fc6d',
            size: 37,
            url: 'https://api.github.com/repos/squadracer/locale-ninja-test/git/blobs/e9101db78943e1f2916e29f5b5bf49715600fc6d'
          },
          {
            path: 'config/locales/animals.it.yml',
            mode: '100644',
            type: 'blob',
            sha: '7702efcf72e9ca309b8bfc02bb9f12dd89076cff',
            size: 21,
            url: 'https://api.github.com/repos/squadracer/locale-ninja-test/git/blobs/7702efcf72e9ca309b8bfc02bb9f12dd89076cff'
          }
        ]
      }.to_json
    end

    def repository_result
      { full_name: 'repo/name', html_url: 'http://example.com' }.to_json
    end
  end
end
