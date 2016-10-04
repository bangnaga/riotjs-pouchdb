import { addCommas } from '../../app.js';
import './productitem.tag';

<productitems>
  <div class="product-search">
    <input type="text" name="search" class="u-full-width" value="" placeholder="Masukkan kata yang ingin dicari dan tekan ⏎"  onblur="{ blur2 }" onkeyup="{ s }">
  </div>
  <div class="product-item">
    <small class="hint">*To update the price, change the price and press ⏎.</small><br/>
    <div class="row" each={ productItems }>
      <productitem title="{title}" price="{price}" stock="{stock}" _id="{_id}"></productitem>
    </div> 
    <div class="pagination u-text-center">
        <ul>
          <li  each={ countItems }  class={ active: done }>
            <a href="./#products?page={id}">{id}</a>
          </li>
        </ul>
    </div>
  </div>

  <script>
    this.productItems = []
    this.countItems = []
    var q = riot.route.query()

    let clearSearch = (s) => {
      riot.control.trigger(riot.EVT.productSearchItem, {text: s})
    };

    this.s = (e) => {
      if(e.which == 13) { // enter
        clearSearch(e.target.value)
      }
    };

    this.on('mount', () => {
      if(!q.page) q.page = 1
      document.getElementById('preloader').style = "display:visible"
      riot.control.trigger(riot.EVT.productLoadItems, {page: q.page})
    });

    riot.control.on(riot.EVT.productLoadItemsSuccess, productItems => {
      this.productItems = productItems.docs.map(function(r){ return r })
      var array = _.range(0, (productItems.total_rows/riot.pageSize)) 
      this.countItems = _.map(array, function (value, key) {
        return {id: (key+1), done: (q.page == (key+1) ? true: false)}
      })
      document.getElementById('preloader').style = "display:none"
      this.update()
    });

    riot.control.on(riot.EVT.productSaveItemSuccess, item => {
      this.productItems.splice(0,0,item)
      alerty.toasts(
          "SUCCESS: New product has been added",
          { place: 'top', bgColor: 'green', time: 2500 }
        )
      this.update()
    });

    riot.control.on(riot.EVT.productUpdateItemSuccess, item => {
      var index = _.indexOf(this.productItems, _.find(this.productItems, {_id: item._id}))
      this.productItems.splice(index, 1, item)
      this.update()
    });

    riot.control.on(riot.EVT.productRemoveItemSuccess, item => {
      var index__ = _.indexOf(this.productItems, _.find(this.productItems, {_id: item._id}))
      if (parseFloat(index__) > -1) {
        this.productItems.splice(index__, 1)
      }
      this.update()
    });

    riot.control.on(riot.EVT.productSearchItemSuccess, searchitems => {
      this.productItems = searchitems
      this.countItems = []
      this.update()
    });

    riot.control.on(riot.EVT.productUpdateItemSuccess, item => {
      var index = _.indexOf(this.productItems, _.find(this.productItems, {_id: item._id}))
      _.assign(this.productItems[index], {isUpdated: true})
      this.update()
    });

  </script>
</productitems>