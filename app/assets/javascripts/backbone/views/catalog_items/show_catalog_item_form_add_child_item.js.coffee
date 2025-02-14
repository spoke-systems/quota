class Quota.Views.ShowCatalogItemFormAddChildItem extends Backbone.View

	template: HandlebarsTemplates['catalog_items/show_catalog_item_form_add_child_item'] #Handlebars.compile($("#quote-template").html()) #JST['quotes/index']
	
	events:
		"click #catalog_item-add-new-child-item-actions .btn-success": "clickAddNewChildItem"
		"click #catalog_search": "clickCatalogSearch"
		
	initialize: (options)->
		self = @
		_.bindAll(@)
		@vent = options.vent
		@vent.on('add_child_item:clicked', @showAddChildItem, @)
		@vent.on('done_add_child_item:clicked', @hideAddChildItem, @)
		@vent.on('manufacturers:loaded', @manufacturersLoaded, @)
		@vent.on('catalog_item_child_items:remove_item', @removeCatalogItemChildItem, @)
		@manufacturers = options.manufacturers
		
		@catalog_item = options.parent_model
		@catalog_item_child_items = options.parent_collection
			
			
		@_itemsView = new Quota.Views.CatalogItemSearchList({parent_child_key: @catalog_item.get("pub_key"), vent: @vent})
		
	render: ->
		$(@el).html(@template({catalog_item:@catalog_item}))
		@manufacturer_name = $('#catalog_item_manufacturer')
		@input_manufacturer_name = $('#catalog_item_manufacturer')
		@input_manufacturer_key = $('.manufacturer_key')
		manufacturer_name_field_name = @input_manufacturer_name.attr('name')
		manufacturer_name_field_id = @input_manufacturer_name.attr('id')
		
		@_manufacturerComboView = new Quota.Views.ManufacturerComboView({parent_model:@model, collection:@manufacturers, el: '#catalog_item_manufacturer', source: "manufacturer", val: "manufacturer", className: 'string input-large', vent: @vent})
		@_manufacturerComboView.render()
		
		@input_manufacturer_name = $('#catalog_item_manufacturer')
				
		@input_manufacturer_name.attr('name', manufacturer_name_field_name)
		@input_manufacturer_name.attr('id', manufacturer_name_field_id)
		
		@input_catalog_item_name = @$('.catalog_item_name input')
		@input_catalog_item_manufacturer_name = @$('.catalog_item_manufacturer input')
		@input_catalog_item_part_number = @$('.catalog_item_part_number input')
		@input_catalog_item_list_price = @$('#catalog_item_list_price')
		@input_catalog_item_list_price_interval = @$('#catalog_item_recurring_unit')
		@input_catalog_item_is_taxable = @$('#catalog_item_is_taxable')
		@input_catalog_item_is_package = @$('#catalog_item_is_package')
		
		@input_catalog_search = @$('.catalog_search input')
		
		@loading = @$('.section-loading')
		@
		
	show: ->
		$(@el).toggle(true)
		
	hide: ->
		$(@el).toggle(false)
		
	showAddChildItem: ->
		@show()
		
	hideAddChildItem: ->
		@hide()
	
	manufacturersReset: ->
		# @vent.trigger('manufacturers:loaded')
		# 		@_manufacturerComboView.setElement(@manufacturer_name).render()
		
	showLoading: ->
		@loading.toggle(true)

	hideLoading: ->
		@loading.toggle(false)
	
	manufacturersLoaded: ->
		# @hideLoading
		# 		@_manufacturerComboView.setElement(@manufacturer_name).render()
		
		
	clickAddNewChildItem: ->
		self = @
		catalog_item = new Quota.Models.CatalogItem()
		    
		catalog_item.save(
			{
				name: @input_catalog_item_name.val()
				manufacturer: @input_manufacturer_name.val()
				part_number: @input_catalog_item_part_number.val()
				list_price: @input_catalog_item_list_price.val()
				recurring_unit: @input_catalog_item_list_price_interval.val()
				is_taxable: @input_catalog_item_is_taxable.is(':checked') 
				is_package: @input_catalog_item_is_package.is(':checked') 
			},
			{
				error: ->
					console.log "save error"
				success: (model) -> 
					self.vent.trigger('catalog_item_child_items:add_new_catalog_item_successful', {model: model})
					
					self.resetAddNewChildItemForm()
					# if model.get("manufacturer") and self.manufacturers.where(name: model.get("manufacturer")).length == 0
					# 						manufacturer = new Quota.Models.Manufacturer({manufacturer: model.get("manufacturer")})
					# 						self.manufacturers.add(manufacturer)
					# 						self._manufacturerComboView = new Quota.Views.ManufacturerComboView({parent_model:self.model, collection:self.manufacturers, el: '#catalog_item_manufacturer', source: "manufacturer", val: "manufacturer", className: 'string input-large', vent: self.vent})
					self.render()
					catalog_item_child = new Quota.Models.CatalogItemChild({parent_key: self.catalog_item.get("pub_key"), child_key: model.get("pub_key")})
					catalog_item_child.save(
						{
							parent_key: catalog_item_child.get("parent_key")
							child_key: catalog_item_child.get("child_key")
						},
						{
							error: ->
								console.log "save error"
							success: (model) -> 
								self.catalog_item_child_items.add(model)
								self.vent.trigger('catalog_item_child_items:add_new_catalog_item_child_successful', {model: model})
								# self._contactsView.contacts.add(model.get("contact"))
						}
					)
			}
		)
	
	clickCatalogSearch: ->
		self = @
		res = new Quota.Collections.CatalogItems()
		res.fetch(
			{
				url: '/api/catalog_items/filter_by_name_or_part_number'
				data: {filter: @input_catalog_search.val()}
				error: ->
					console.log "save error"
				success: (collection, response, options) -> 
					self.renderSearchResults(collection)
			}
		)
	
	removeCatalogItemChildItem: (item)->
		# @_contactsView.setElement(@container_contacts).render()
		
	renderSearchResults: (collection)->
		@$('#catalog_search_container').show()
		@_itemsView.collection = collection
		@container_search_item_list = @$('#catalog_search_container')
		@_itemsView.setElement(@container_search_item_list).render()
		
		
	resetAddNewChildItemForm: ->
		@input_catalog_item_name.val('')
		@input_catalog_item_manufacturer_name.val('')
		@input_catalog_item_part_number.val('')
		@input_catalog_item_list_price.val('')
		@input_catalog_item_list_price_interval.val('')
		@input_catalog_item_is_taxable.attr('checked', false)
		@input_catalog_item_is_package.attr('checked', false)