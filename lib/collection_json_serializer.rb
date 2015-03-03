# I know it sucks to add every file manually, but for now I want to
# visualize the full list of files and how they are organized
require "collection_json_serializer/version"
require "collection_json_serializer/mime_type"

require "collection_json_serializer/core_ext/hash"
require "collection_json_serializer/core_ext/symbol"

require "collection_json_serializer/support"

require "collection_json_serializer/serializer"
require "collection_json_serializer/items"
require "collection_json_serializer/spec"
require "collection_json_serializer/builder"

require "collection_json_serializer/validation/base"
require "collection_json_serializer/validator"
require "collection_json_serializer/validation/items_validator"
require "collection_json_serializer/validation/types/url"
require "collection_json_serializer/validation/types/value"

require "collection_json_serializer/objects/item"
require "collection_json_serializer/objects/template"
require "collection_json_serializer/objects/query"

require "collection_json_serializer/extensions/template_validation"

require "active_support/core_ext/object/blank"
require "active_support/core_ext/string/inflections"
require "active_support/json"
