class Quota.Collections.ContactTypes extends Backbone.Collection

	model: Quota.Models.ContactType
	url: '/api/contact_types'
	comparator: (ct) ->
		return !ct.get("is_default")
