class Quota.Views.IndexContactAddressesList extends Backbone.View

	
	# template: HandlebarsTemplates['opportunities/show_opp_contacts_list'] #Handlebars.compile($("#quote-template").html()) #JST['quotes/index']
	# el: '#contact_addresses_container .section-table tbody'
	el: '.contact_addresses .contact_addresses_list'
	
	# events:
	# 		"click .contact_remove": "destroy"
	
	initialize: (options)->
		_.bindAll(@)
		@vent = options.vent
		@_addressViews = []
		@collection.on('reset', @collectionReset, @)
		@collection.on('destroy:error', @removeFailed, @)
		@collection.on('destroy:success', @removeSuccess, @)
		@contact = options.parent_model
		
		@vent.on('contact_addresses:save_new_contact_address_successful', @addNewAddress_Success, @)
		
		
	render: ->
		# $(@el).html(@template({}))
		frag = document.createDocumentFragment()
		frag.appendChild(@addOne(item).render().el) for item in @collection.models
		@$el.append(frag)
		
		@

	addOne: (item)->
		# view = new Quota.Views.EditContactAddress({model: item, tagName:'tr', contact: @model, vent: @vent, index: (@collection.models.length - 1)})
		view = new Quota.Views.IndexContactAddress({model: item, tagName:'li', contact: @model, vent: @vent, index: (@collection.models.length - 1)})
		@_addressViews.push(view)
		view

	collectionReset: ->
		@render()

	removeFailed: (evt) ->
		view = _.find(@_addressViews, (view) -> view.model == evt.model)
		view.toggle()

	removeSuccess: (evt) ->
		# console.log "got here"

	# destroy: (evt) ->
	# 		$(@el).toggle()
	# 		# @model.trigger('removing', {view: @})
	# 		@model.remove()

	hideRemove: () ->
		@hideRemove = true
		@$el.find('.address_remove').css('visibility', 'hidden')

	showRemove: () ->
		@hideRemove = false
		@$el.find('.address_remove').css('visibility', '')
		
	addNewAddress_Success: (obj)->
		model = obj.model
		self = @

		# self.collection.add(model)
		view = self.addOne(model)
		frag = document.createDocumentFragment()
		frag.appendChild(view.render().el)
		self.$el.append(frag)

		view.handleEdit()

	

	handleError: (attribute, message) ->
		console.log message