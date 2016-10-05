import { addCommas } from '../../app.js';

<addproduct>
  <form id='addProductForm' style="margin-bottom:0px">
    <div class="eight columns">
        <input type="text" name="item" class="u-full-width {this.item_error ? 'has-error' : 'has-success'}" value="" placeholder="Fill product name" oninput="{oninputitem}" onkeyup="{save}">
        <small class="hint">*Press ⏎ (enter/return) to add new product</small>
    </div>
    <div class="four columns">
        <input type="text" id="price" name="price" class="u-full-width u-text-right {this.price_error ? 'has-error' : 'has-success'}" value="" placeholder="Fill the price" oninput="{oninputprice}" onkeyup="{save}">
        <input type="submit" value="Add" class="button" style="display:none">
    </div>
  </form>
   

  <script>
    var self = this;
    var ENTER_KEY = 13;
    this.item_error = true
    this.price_error = true
    this.price_ = 0
    
    this.oninputitem = () => {
      if(this.item.value != "") {
        this.item_error = false
      } else {
        this.item_error = true
      }
    };

    this.oninputprice = () => {
      var prize__ = parseFloat(this.price.value)
      if(prize__ > 0 || !isNaN(prize__)) {
        this.price_error = false
      } else {
        this.price_error = true
      }
      this.price_ = parseFloat(this.price.value.replace(".", ""))
      this.price.value=addCommas(this.price.value.replace(/[^0-9-]/g,''))
    };

    let reset = () => {
      this.item.value = ''
      this.price.value = '0'
      this.id_edit = false
      this.item.disabled = false
      this.item.focus()
      this.update()
    };

    this.save = (e) => {
      var prize_ = parseFloat(this.price_)
      if (e.which === ENTER_KEY) {
        if (this.item.value && (prize_ > 0 || !isNaN(prize_))) {
          var item = {
            title: this.item.value,
            price: prize_,
            stock: 0
          }

          if(this.is_edit) {
            item['_id'] = this.item.idvalue
          }

          riot.control.trigger(riot.EVT.productSaveItem, item)
          reset()
        }
      }
      return false
    };

    this.cancel = (e) => {
      reset()
    };

    riot.control.on(riot.EVT.productEditItemOn, item => {
      this.is_edit = true
      this.item.value = item.title
      this.item.disabled = true
      this.item.idvalue = item._id
      this.price.value = item.price
      this.stock.value = item.stock
      this.item.focus()
      this.update()
    });

  </script>
</addproduct>