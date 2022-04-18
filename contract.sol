pragma solidity  <0.9.0;

contract Marketplace {
    
    uint public productCount = 0;
    mapping(uint => Product) public products;
    mapping(address => Request_wrapper) public requests_wrapper;
  

    struct Product {
        uint id;
        string name;
        address  owner;
        
    }

     struct Request {
        
        uint productID;
        address  owner;
        
    }

     struct Request_wrapper{

        uint requestCount; 
        mapping(uint => Request) requests;

    }
    function getRequestCount() public view returns(uint) {

    return requests_wrapper[msg.sender].requestCount;
   
    }


    function getRequest(uint _rcount) public view returns(Request memory) {
        return requests_wrapper[msg.sender].requests[_rcount];

    }



   

    function createProduct(string memory _name) public {
        // Require a valid name
        require(bytes(_name).length > 0);
        // Require a valid price
       
        // Increment product count
        productCount ++;
        // Create the product
        products[productCount] = Product(productCount, _name, msg.sender);
        // Trigger an event
        emit ProductCreated(productCount, _name,  msg.sender);
    }

    function purchaseProduct(uint _id,uint _rcount) public  {
         
        // fetch requests
       require(_id>0);
       
        Request memory _request=getRequest(_rcount);
        // Fetch the product
        Product memory _product = products[_request.productID];
        // Fetch the owner
        address  _seller = _product.owner;
        // Make sure the product has a valid id
        require(_product.id > 0 && _product.id <= productCount);
        // Require that there is enough Ether in the transaction
      
        require(_seller != _request.owner);
        // Transfer ownership to the buyer
        _product.owner = _request.owner;
        
        products[_request.productID] = _product;
      

      requests_wrapper[_seller].requests[_rcount]= requests_wrapper[_seller].requests[requests_wrapper[_seller].requestCount];
         requests_wrapper[_seller].requestCount--;
        emit ProductPurchased(productCount, _product.name, _request.owner);
    }

  
    

    function requestProduct(uint _id) public  {
        // Fetch the product
        Product memory _product = products[_id];
        // Fetch the owner
        address  _seller = _product.owner;
        // Make sure the product has a valid id
        require(_product.id > 0 && _product.id <= productCount);
        
        require(_seller != msg.sender);

        

        requests_wrapper[_seller].requestCount++;
        requests_wrapper[_seller].requests[requests_wrapper[_seller].requestCount]=Request(_id,msg.sender) ;

        


    // requests_wrapper[_seller]=_requests;  
    }

    
}