import '../components/products/addproduct.tag';
import '../components/products/productitems.tag';

<products>
  <div class="container products">
    <div class="row">
      <div class="twelve columns">
          <h3>Products</h3>
          <h6>Add Product</h6>
          <div class="row product-add">
            <addproduct></addproduct>
          </div>
          <br/>
          <h6>List of All Products</h6>
          <div class="product-items">
            <productitems title="Cart Item List"></productitems>                
          </div>
        </div>
      </div>
  </div>

  <script>
    this.on('mount', () => {
      console.log("Products mounted")
    });
  </script>

</products>