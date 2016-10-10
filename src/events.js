import Riotcontrol from 'riotcontrol'

riot.control = Riotcontrol

// EVENT NAMES
riot.EVT = {
  // Products
  productLoadItems         : 'product_load_items',
  productLoadItemsSuccess  : 'product_load_items_success',
  productSaveItem          : 'product_save_item',
  productSaveItemSuccess   : 'product_save_item_success',
  productEditItemOn        : 'product_edit_item_on',
  productUpdateItemSuccess : 'product_update_item_success',
  productRemoveItem        : 'product_remove_item',
  productRemoveItemSuccess : 'product_remove_item_success',
  productSearchItem        : 'product_search_product',
  productSearchItemSuccess : 'product_search_product_success'
}

/* DB CONFIGURATION */
riot.db = new PouchDB('riotpouch')
// riot.db.destroy().then(function () {
//   // database destroyed
// }).catch(function (err) {
//   // error occurred
// })
riot.pageSize = 10
riot.offset = riot.pageSize