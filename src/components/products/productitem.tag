import { addCommas } from '../../app.js';

<productitem>
  <div class="eight columns product-item-name">
      <label>{ this.title } <small class="green">{ "✔ updated": this.isUpdated }</small></label>
      <input type="hidden" name="item_single" value="{ this.title }">
  </div>
  <div class="three columns u-text-right product-item-price">
      <input type="text" min="1" name="price_single" class="u-full-width u-text-right" value="{ price_update_ }" onkeyup="{edit}" oninput="{oninputprice_single}">
  </div>
  <div class="one columns u-text-right product-item-price">
      <a href="#{this._id}" onclick={remove}>[x]</a>
  </div>
  <script>
    var self = this;
    this.price_single_ = String(this.price).replace(".", "")
    this.prize_ = parseFloat(this.price_single_)
    self.removed = false
    self.isUpdated = false

    this.on('update', () => {
      this.price_update_ = addCommas(this.price_single_)
    });

    this.oninputprice_single = () => {
      var prize__ = parseFloat(this.price_single.value)
      if(prize__ > 0 || !isNaN(prize__)) {
        this.price_error = false
      } else {
        this.price_error = true
      }
      this.price_single_ = parseFloat(this.price_single.value.replace(".", ""))
      this.price_single.value=addCommas(this.price_single.value.replace(/[^0-9-]/g,''))
    };

    this.edit = (e) => {
      if(e.which == 13) { // escape
        var prize_ = parseFloat(this.price_single_)
        if (this.item_single.value && (prize_ > 0 || !isNaN(prize_))) {
          var item = {
            _id: opts._id,
            title: this.item_single.value,
            price: prize_,
            stock: 0,
            created: opts.created
          }
          riot.control.trigger(riot.EVT.productSaveItem, item)
        }
      }
    };

    this.remove = (e) => {
      var r = confirm("Remove \""+this.title+"\" ?");
      if (r == true) {
          var opts = {_id: this._id}
          riot.control.trigger(riot.EVT.productRemoveItem, opts)
      } else {
          return false;
      }
    };

  </script>
</productitem>