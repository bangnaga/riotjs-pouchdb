class ProductStore{

  constructor(){
    riot.observable(this);
    this.productItems = [];

    this.db = riot.db;
    this.edit_id = false;
    this.pageSize = riot.pageSize;
    this.offset = riot.offset;
    this.bindEvents();
  }

  bindEvents(){
    var self = this;
    let productsTriggerChangeds = (d) => {
      this.trigger(riot.EVT.productLoadItemsSuccess, d)
    };


    let productLoadItems = () => {

      /* FIND METHOD */
      self.db.createIndex({
           index: {
            fields: ['created', 'type'],
            name: 'myproductindex',
            ddoc: 'myproductdoc',
            type: 'json',
          }
      }).then(function() {
          return self.db.find({
              selector: {'created': {$gt: 0}, 'type': 'item'},
              fields: ['created', 'price','type','title', '_id'],
              sort: [{'created': 'desc'}],
              limit: self.pageSize, 
              skip: self.offset, 
              include_docs : true
          }).then(function (result) {
            productsTriggerChangeds(result);
          }).catch(function (err) {
            console.log(err);
          });
      }).then(function () {
        return self.db.getIndexes().then(function (result) {
          result.indexes.forEach(function (value, i) {
            if(value.name == "myproductindex") {
              self.db.deleteIndex({
                "name": "myproductindex",
                "ddoc": value.ddoc,
              })  
            }
          });
        }).catch(function (err) {
          // ouch, an error
        });
      });
    }

    let productAddTodo = (item) => {
      this.db.put(item, function callback(err, result) {
        if (!err) {
          this.trigger(riot.EVT.productSaveItemSuccess, item);
        } else {
          console.log(err);
        }
      }.bind(this)); 
    };

    let productUpdateTodo = (item) => {
      this.db.get(self.edit_id).then(function (origDoc) {
        item._rev = origDoc._rev;
        return this.db.put(item);
      }).catch(function (err) {
        if (err.status === 409) {
          console.log(err);
        } else {
          self.edit_id = false;
          this.trigger(riot.EVT.productUpdateItemSuccess, item);
          return this.db.put(item);
        }
      }.bind(this));
    };

    let productRemoveTodo = (item) => {
      this.db.get(item._id).then(function (origDoc) {
        item._rev = origDoc._rev;
        self.trigger(riot.EVT.productRemoveItemSuccess, item);
        return self.db.remove(item);
      }).catch(function (err) {
        if (err.status === 409) {
          console.log(err);
        } else {
          return self.db.remove(item);
        }
      });
    };

    let productSearchItem = (text) => {
      var s = text.text;
      var regexp = new RegExp(s, 'i'); // Case Insensitive
      // this.db.find({
      //   selector: {
      //       type: "item",
      //       title: {$regex: regexp}
      //     }
      // }).then(function (result) {
      //   console.log(result)
      //   self.trigger(riot.EVT.productSearchItemSuccess, result.docs);
      // }).catch(function (err) {
      //   console.log(err);
      // });
      self.db.createIndex({
           index: {
            fields: ['title', 'type'],
            name: 'mysearchproductindex',
            ddoc: 'mysearchproductdoc',
            type: 'json',
          }
      }).then(function() {
          return self.db.find({
              selector: {'title': {$regex: regexp}, 'type': 'item'},
              fields: ['title', 'type', 'created', 'price', '_id'],
              // sort: [{'title': 'asc'}],
              limit: self.pageSize, 
              // skip: self.offset, 
              include_docs : true
          }).then(function (result) {
            self.trigger(riot.EVT.productSearchItemSuccess, result.docs);
          }).catch(function (err) {
            console.log(err);
          });
      }).then(function () {
        return self.db.getIndexes().then(function (result) {
          result.indexes.forEach(function (value, i) {
            if(value.name == "mysearchproductindex") {
              self.db.deleteIndex({
                "name": "mysearchproductindex",
                "ddoc": value.ddoc,
              })  
            }
          });
        }).catch(function (err) {
          // ouch, an error
        });
      });
    }

    this.on(riot.EVT.productLoadItems, (opts) => {
      if(opts.page) {
        this.offset = ((parseFloat(opts.page) - 1) * this.pageSize);
      }
      productLoadItems();
    });

    this.on(riot.EVT.productRemoveItem, (opts) => {
      productRemoveTodo(opts);
    });

    this.on(riot.EVT.productSaveItem, (opts) => {
      if(opts._id) {
        self.edit_id = opts._id;
      }

      var _myId = opts.title;
      _myId = _myId.replace(/\W/g,'');

      var createdOn = Math.floor(Date.now() / 1000)

      var item = {
        _id: 'item_'+_myId,
        title: opts.title,
        price: opts.price,
        stock: opts.stock,
        type: 'item',
        created: createdOn
      };

      if(self.edit_id) {
        productUpdateTodo(item);
      } else {
        productAddTodo(item);
      }

    });

    this.on(riot.EVT.productSearchItem, (s) => {
      productSearchItem(s);
    });
  }

}

// add store to riot control
let productStore = new ProductStore();
riot.control.addStore(productStore);

export default productStore;